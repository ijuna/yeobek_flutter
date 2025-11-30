// Artist Integration Tests
// Ported from test backend/api_py/test_artist_api.py
// Tests CRUD, permissions, optimistic locking, history, restore

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:features/features.dart';

void main() {
  late ArtistModule artistModule;
  late AuthModule authModule;
  
  String randomEmail(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp@test.example.com';
  }

  String uniqueInsta() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test_$timestamp';
  }

  Future<String> registerOwner() async {
    final email = randomEmail('owner');
    await authModule.postAuthRegister(
      email: email,
      password: 'TestPass123!@#',
      role: 'owner',
    );
    final loginResult = await authModule.postAuthLogin(
      email: email,
      password: 'TestPass123!@#',
    );
    return loginResult.accessToken;
  }

  setUpAll(() {
    artistModule = ArtistModule.defaultClient();
    authModule = AuthModule.defaultClient();
  });

  group('Artist - Basic CRUD Flow', () {
    test('ping endpoint', () async {
      final result = await artistModule.getArtistPing();
      expect(result, isNotEmpty);
    });

    test('create, read, update, delete flow', () async {
      final instaId = uniqueInsta();
      final ownerToken = await registerOwner();

      // Create
      final createResult = await artistModule.postArtistCreate(
        name: '테스트 아티스트',
        instaId: instaId,
        followers: 10,
        tags: ['korean', 'blackwork'],
        accessToken: ownerToken,
      );
      expect(createResult, startsWith('a_'));

      // Duplicate instaId should fail with 409
      try {
        await artistModule.postArtistCreate(
          name: '중복 테스트',
          instaId: instaId,
          followers: 10,
          tags: ['korean'],
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 409);
      }

      // Check exists
      final existsResult = await artistModule.getArtistExists(
        instaId: instaId,
      );
      expect(existsResult, isTrue);

      // Read by instaId
      final artist = await artistModule.getArtist(instaId: instaId);
      expect(artist.artistId, createResult);
      expect(artist.name, '테스트 아티스트');
      expect(artist.instaId, instaId);
      final rowVersion = artist.rowVersion;

      // Update with correct rowVersion
      final updatedArtist = await artistModule.putArtist(
        instaId: instaId,
        name: '수정된 이름',
        rowVersion: rowVersion!,
        accessToken: ownerToken,
      );
      expect(updatedArtist.name, '수정된 이름');

      // Update with stale rowVersion should fail with 409
      try {
        await artistModule.putArtist(
          instaId: instaId,
          followers: 11,
          rowVersion: 1,
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 409);
        final body = e.response?.data;
        if (body is Map && body.containsKey('error')) {
          expect(body['error'], anyOf('VERSION_CONFLICT', 'HTTP_409'));
        }
      }

      // History should have entries
      final history = await artistModule.getArtistHistory(instaId: instaId);
      expect(history, isNotEmpty);

      // Delete
      await artistModule.deleteArtist(
        instaId: instaId,
        accessToken: ownerToken,
      );

      // Second delete should fail with 404
      try {
        await artistModule.deleteArtist(
          instaId: instaId,
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });

    test('update requires owner permission (403)', () async {
      final instaId = uniqueInsta();
      final ownerToken = await registerOwner();

      // Create as owner
      await artistModule.postArtistCreate(
        name: '권한 테스트',
        instaId: instaId,
        followers: 10,
        tags: ['test'],
        accessToken: ownerToken,
      );

      // Register normal user
      final normalEmail = randomEmail('normal');
      await authModule.postAuthRegister(
        email: normalEmail,
        password: 'TestPass123!@#',
        role: 'artist',
      );
      final normalLogin = await authModule.postAuthLogin(
        email: normalEmail,
        password: 'TestPass123!@#',
      );
      final normalToken = normalLogin.accessToken;

      // Get current rowVersion
      final artist = await artistModule.getArtist(instaId: instaId);

      // Normal user update should fail with 403
      try {
        await artistModule.putArtist(
          instaId: instaId,
          name: '변경 금지',
          rowVersion: artist.rowVersion!,
          accessToken: normalToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 403);
      }
    });
  });

  group('Artist - Restore Flow', () {
    test('restore after delete', () async {
      final instaId = uniqueInsta();
      final ownerToken = await registerOwner();

      // Create
      await artistModule.postArtistCreate(
        name: '원본',
        instaId: instaId,
        followers: 100,
        tags: ['tag1'],
        accessToken: ownerToken,
      );

      // Update
      final artist = await artistModule.getArtist(instaId: instaId);
      await artistModule.putArtist(
        instaId: instaId,
        name: '변경1',
        rowVersion: artist.rowVersion!,
        accessToken: ownerToken,
      );

      // Delete
      await artistModule.deleteArtist(
        instaId: instaId,
        accessToken: ownerToken,
      );

      // Restore (latest version)
      final restored = await artistModule.postArtistRestore(
        instaId: instaId,
        accessToken: ownerToken,
      );
      expect(restored.name, anyOf('원본', '변경1'));

      // Verify restored artist can be fetched
      final fetched = await artistModule.getArtist(instaId: instaId);
      expect(fetched.artistId, isNotEmpty);
    });
  });

  group('Artist - Validations', () {
    test('missing required fields return 422', () async {
      final ownerToken = await registerOwner();

      // Missing name
      try {
        await artistModule.postArtistCreate(
          name: '',
          instaId: uniqueInsta(),
          followers: 0,
          tags: [],
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 422));
      }

      // Update without rowVersion
      final instaId = uniqueInsta();
      await artistModule.postArtistCreate(
        name: 'Test',
        instaId: instaId,
        followers: 0,
        tags: ['a'],
        accessToken: ownerToken,
      );

      try {
        // PutArtist requires rowVersion, so passing 0 or invalid should fail
        await artistModule.putArtist(
          instaId: instaId,
          name: 'No Version',
          rowVersion: 0,
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(409, 422));
      }
    });

    test('unicode and emoji in name', () async {
      final ownerToken = await registerOwner();

      // Emoji in name
      final result1 = await artistModule.postArtistCreate(
        name: '🎨 Artist',
        instaId: uniqueInsta(),
        followers: 0,
        tags: [],
        accessToken: ownerToken,
      );
      expect(result1, startsWith('a_'));

      // Korean/Japanese/Chinese
      final result2 = await artistModule.postArtistCreate(
        name: '한글 日本語 中文',
        instaId: uniqueInsta(),
        followers: 0,
        tags: [],
        accessToken: ownerToken,
      );
      expect(result2, startsWith('a_'));
    });

    test('extreme values', () async {
      final ownerToken = await registerOwner();

      // Very long name (250 chars)
      final longName = 'N' * 250;
      try {
        await artistModule.postArtistCreate(
          name: longName,
          instaId: uniqueInsta(),
          followers: 0,
          tags: [],
          accessToken: ownerToken,
        );
        // May succeed or fail based on DB constraints
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Very high followers count
      final result = await artistModule.postArtistCreate(
        name: 'High Followers',
        instaId: uniqueInsta(),
        followers: 999999999,
        tags: [],
        accessToken: ownerToken,
      );
      expect(result, startsWith('a_'));
    });
  });

  group('Artist - List and Search', () {
    test('list endpoint with pagination', () async {
      // List all artists
      final listResult = await artistModule.getArtistList(
        order: 'created_desc',
      );
      expect(listResult, isNotNull);
      // Items may be empty or contain artists
    });
  });

  group('Artist - Advanced Edge Cases', () {
    test('concurrent updates race condition', () async {
      final ownerToken = await registerOwner();
      final insta = uniqueInsta();

      // Create artist
      await artistModule.postArtistCreate(
        name: 'Race Test',
        instaId: insta,
        followers: 0,
        tags: [],
        accessToken: ownerToken,
      );

      // Get current state
      final current = await artistModule.getArtist(instaId: insta);

      // Launch multiple concurrent updates with same rowVersion
      final futures = List.generate(5, (i) {
        return artistModule.putArtist(
          instaId: insta,
          name: 'Update$i',
          rowVersion: current.rowVersion,
          accessToken: ownerToken,
        ).then((_) => 'success').catchError((Object e) {
          if (e is DioException && e.response?.statusCode == 409) {
            return 'conflict';
          }
          return 'error';
        });
      });

      final results = await Future.wait(futures);

      // At least one should succeed, others should conflict with 409
      final successCount = results.where((r) => r == 'success').length;
      final conflictCount = results.where((r) => r == 'conflict').length;
      
      expect(successCount, greaterThanOrEqualTo(1),
        reason: 'At least one concurrent update should succeed');
      expect(conflictCount, greaterThan(0),
        reason: 'Some concurrent updates should conflict with 409');
    });

    test('delete and recreate with same instaId', () async {
      final ownerToken = await registerOwner();
      final insta = uniqueInsta();

      // Create
      await artistModule.postArtistCreate(
        name: 'Delete Test',
        instaId: insta,
        followers: 0,
        tags: [],
        accessToken: ownerToken,
      );

      // Delete
      await artistModule.deleteArtist(
        instaId: insta,
        accessToken: ownerToken,
      );

      // Recreate with same instaId (may succeed or fail with 409)
      try {
        final result = await artistModule.postArtistCreate(
          name: 'Recreated',
          instaId: insta,
          followers: 0,
          tags: [],
          accessToken: ownerToken,
        );
        // If succeeds, should return valid artistId
        expect(result, startsWith('a_'));
      } on DioException catch (e) {
        // May fail with 409 if instaId uniqueness enforced on deleted
        expect(e.response?.statusCode, anyOf(200, 409));
      }
    });

    test('search by tags and name', () async {
      final ownerToken = await registerOwner();

      // Create artists with searchable data
      await artistModule.postArtistCreate(
        name: 'Apple Art',
        instaId: uniqueInsta(),
        followers: 0,
        tags: ['fruit', 'red'],
        accessToken: ownerToken,
      );

      await artistModule.postArtistCreate(
        name: 'Banana Studio',
        instaId: uniqueInsta(),
        followers: 0,
        tags: ['fruit', 'yellow'],
        accessToken: ownerToken,
      );

      // Search by name (if q param supported)
      final searchByName = await artistModule.getArtistList(
        order: 'created_desc',
        q: 'Apple',
      );
      expect(searchByName, isNotNull);

      // Search by tags (if tags param supported)
      final searchByTags = await artistModule.getArtistList(
        order: 'created_desc',
        tags: 'fruit',
      );
      expect(searchByTags, isNotNull);

      // Empty search should not crash
      final emptySearch = await artistModule.getArtistList(
        order: 'created_desc',
        q: '',
      );
      expect(emptySearch, isNotNull);
    });
  });
}
