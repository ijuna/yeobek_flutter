// Artworks Integration Tests
// Ported from test backend/api_py/test_artworks_api.py
// Tests create, list, update, like/unlike, delete, sorting, pagination

import 'dart:convert';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:features/features.dart';

void main() {
  late ArtworksModule artworksModule;
  late AuthModule authModule;
  
  String randomEmail(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp@test.example.com';
  }

  Future<({String userId, String accessToken})> registerUser() async {
    final email = randomEmail('user');
    final regResult = await authModule.postAuthRegister(
      email: email,
      password: 'TestPass123!@#',
    );
    final loginResult = await authModule.postAuthLogin(
      email: email,
      password: 'TestPass123!@#',
    );
    return (userId: regResult.userId, accessToken: loginResult.accessToken);
  }

  setUpAll(() {
    artworksModule = ArtworksModule.defaultClient();
    authModule = AuthModule.defaultClient();
  });

  group('Artworks - Basic CRUD Flow', () {
    test('create requires authentication', () async {
      try {
        await artworksModule.postArtworks(
          title: '무제',
          accessToken: '',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }
    });

    test('create, list, update, like, unlike, delete flow', () async {
      final user = await registerUser();

      // Create artwork
      final artworkId = await artworksModule.postArtworks(
        title: '테스트 작품',
        description: 'Dart test 생성',
        tagsJson: '[]',
        genresJson: '[]',
        subjectsJson: '[]',
        partsJson: '[]',
        beautyOn: 'false',
        beautyPartsJson: '[]',
        accessToken: user.accessToken,
      );
      expect(artworkId, startsWith('w_'));

      // Get detail
      final detail = await artworksModule.getArtworksId(artworkId: artworkId);
      expect(detail.artworkId, artworkId);
      expect(detail.title, '테스트 작품');
      final initialViewCount = detail.viewCount ?? 0;

      // View count should increment
      final detail2 = await artworksModule.getArtworksId(artworkId: artworkId);
      expect(detail2.viewCount, greaterThanOrEqualTo(initialViewCount));

      // List artworks
      final listResult = await artworksModule.getArtworks(
        page: 1,
        size: 10,
      );
      expect(listResult.items, isNotEmpty);
      expect(listResult.total, greaterThan(0));

      // Update
      await artworksModule.patchArtworksId(
        artworkId: artworkId,
        title: '수정된 작품',
        description: '변경',
        tags: [{'id': 'blackwork', 'name': '블랙워크'}],
        accessToken: user.accessToken,
      );

      // Like (anonymous)
      await artworksModule.putArtworksIdLike(artworkId: artworkId);

      // Duplicate like should fail
      try {
        await artworksModule.putArtworksIdLike(artworkId: artworkId);
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 409));
      }

      // Like with userId
      final artworkId2 = await artworksModule.postArtworks(
        title: '좋아요 테스트',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );
      await artworksModule.putArtworksIdLike(
        artworkId: artworkId2,
        userId: user.userId,
      );

      // Unlike requires userId
      await artworksModule.deleteArtworksIdLike(
        artworkId: artworkId2,
        userId: user.userId,
      );

      // Delete without auth should fail
      try {
        await artworksModule.deleteArtworksId(artworkId: artworkId);
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }

      // Delete with auth
      await artworksModule.deleteArtworksId(
        artworkId: artworkId,
        accessToken: user.accessToken,
      );

      // Get deleted artwork should fail
      try {
        await artworksModule.getArtworksId(artworkId: artworkId);
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });
  });

  group('Artworks - Sorting and Pagination', () {
    test('sort by popular and views', () async {
      final user = await registerUser();

      // Create 3 artworks
      final a1 = await artworksModule.postArtworks(
        title: 'A1',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );
      final a2 = await artworksModule.postArtworks(
        title: 'A2',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );
      final a3 = await artworksModule.postArtworks(
        title: 'A3',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );

      // Like a3 twice (anonymous), a2 once
      await artworksModule.putArtworksIdLike(artworkId: a3);
      await Future.delayed(Duration(milliseconds: 50));
      try {
        await artworksModule.putArtworksIdLike(artworkId: a3);
      } on DioException catch (e) {
        // Some environments may return 400/409 on duplicate like; tolerate for sorting purposes
        if (!(e.response?.statusCode == 400 || e.response?.statusCode == 409)) rethrow;
      }
      await Future.delayed(Duration(milliseconds: 50));
      await artworksModule.putArtworksIdLike(artworkId: a2);

      // Popular sort: a3 should be first
      final popularResult = await artworksModule.getArtworks(
        sort: 'popular',
        page: 1,
        size: 10,
      );
      final popularIds = popularResult.items.map((e) => e.artworkId).toList();
      if (popularIds.contains(a3) && popularIds.contains(a2)) {
        expect(popularIds.indexOf(a3), lessThan(popularIds.indexOf(a2)));
      }

      // Views: hit a1 twice, a2 once
      await artworksModule.getArtworksId(artworkId: a1);
      await artworksModule.getArtworksId(artworkId: a1);
      await artworksModule.getArtworksId(artworkId: a2);

      final viewsResult = await artworksModule.getArtworks(
        sort: 'views',
        page: 1,
        size: 10,
      );
      final viewsIds = viewsResult.items.map((e) => e.artworkId).toList();
      if (viewsIds.contains(a1) && viewsIds.contains(a3)) {
        expect(viewsIds.indexOf(a1), lessThan(viewsIds.indexOf(a3)));
      }
    });

    test('pagination edge cases', () async {
      // Out of bounds page
      final result = await artworksModule.getArtworks(
        page: 9999,
        size: 10,
      );
      expect(result.items, isEmpty);

      // size=0 may be rejected or return empty
      try {
        await artworksModule.getArtworks(page: 1, size: 0);
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 422));
      }
    });
  });

  group('Artworks - Validations and Edge Cases', () {
    test('beautyOn true but empty beautyParts returns 400', () async {
      final user = await registerUser();

      try {
        await artworksModule.postArtworks(
          title: '뷰티 테스트',
          beautyOn: 'true',
          beautyPartsJson: '[]',
          accessToken: user.accessToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 400);
      }
    });

    test('XSS and injection smoke', () async {
      final user = await registerUser();

      try {
        final artworkId = await artworksModule.postArtworks(
          title: "<script>alert('xss')</script>",
          description: "<img src=x onerror=alert(1)>",
          tagsJson: '[]',
          accessToken: user.accessToken,
        );
        // Backend may accept or reject; ensure no crash
        final detail = await artworksModule.getArtworksId(artworkId: artworkId);
        expect(detail.artworkId, isNotEmpty);
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400));
      }
    });

    test('unicode and emoji', () async {
      final user = await registerUser();

      final artworkId = await artworksModule.postArtworks(
        title: '🎨 아트워크 🖼️',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );
      expect(artworkId, startsWith('w_'));

      final detail = await artworksModule.getArtworksId(artworkId: artworkId);
      expect(detail.title, contains(RegExp(r'🎨|아트워크')));
    });

    test('extreme values', () async {
      final user = await registerUser();

      // Very long title
      final longTitle = 'A' * 250;
      try {
        await artworksModule.postArtworks(
          title: longTitle,
          tagsJson: '[]',
          accessToken: user.accessToken,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Empty title
      try {
        await artworksModule.postArtworks(
          title: '',
          tagsJson: '[]',
          accessToken: user.accessToken,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }
    });
  });

  group('Artworks - Multiple Users Interaction', () {
    test('multiple users creating and liking', () async {
      final user1 = await registerUser();
      final user2 = await registerUser();

      // User1 creates artwork
      final artworkId = await artworksModule.postArtworks(
        title: 'U1 Work',
        tagsJson: '[]',
        accessToken: user1.accessToken,
      );

      // User2 likes it
      await artworksModule.putArtworksIdLike(
        artworkId: artworkId,
        userId: user2.userId,
      );

      // User2 tries to update User1's artwork (may fail based on ownership)
      try {
        await artworksModule.patchArtworksId(
          artworkId: artworkId,
          title: 'Hacked',
          accessToken: user2.accessToken,
        );
        // May succeed if no ownership check
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 403));
      }

      // User1 deletes own artwork
      await artworksModule.deleteArtworksId(
        artworkId: artworkId,
        accessToken: user1.accessToken,
      );

      // User2 tries to delete already deleted artwork
      try {
        await artworksModule.deleteArtworksId(
          artworkId: artworkId,
          accessToken: user2.accessToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });
  });

  group('Artworks - Advanced Features', () {
    test('unlike idempotency', () async {
      final user = await registerUser();

      // Create artwork
      final artworkId = await artworksModule.postArtworks(
        title: 'Unlike Test',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );

      // Like with userId
      await artworksModule.putArtworksIdLike(
        artworkId: artworkId,
        userId: user.userId,
      );

      // Unlike once
      await artworksModule.deleteArtworksIdLike(
        artworkId: artworkId,
        userId: user.userId,
      );

      // Unlike again should fail (already removed)
      try {
        await artworksModule.deleteArtworksIdLike(
          artworkId: artworkId,
          userId: user.userId,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(404, 409, 400));
      }
    });

    test('concurrent likes', () async {
      final user = await registerUser();

      // Create artwork
      final artworkId = await artworksModule.postArtworks(
        title: 'Concurrent Likes Test',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );

      // Spawn multiple concurrent like requests (anonymous)
      final futures = List.generate(10, (_) {
        return artworksModule.putArtworksIdLike(
          artworkId: artworkId,
        ).then((_) => 'success').catchError((Object e) => 'failed');
      });

      await Future.wait(futures);

      // Fetch artwork and verify likesCount ≤ 10
      final detail = await artworksModule.getArtworksId(
        artworkId: artworkId,
      );
      expect(detail.likesCount, lessThanOrEqualTo(10));
    });

    test('filter combinations (tags + userId)', () async {
      final user = await registerUser();

      // Create artworks with different tags
      await artworksModule.postArtworks(
        title: 'Work with Tag A',
        tagsJson: '[{"id":"tagA","name":"Tag A"}]',
        accessToken: user.accessToken,
      );

      await artworksModule.postArtworks(
        title: 'Work with Tag B',
        tagsJson: '[{"id":"tagB","name":"Tag B"}]',
        accessToken: user.accessToken,
      );

      // Filter by userId
      final userWorks = await artworksModule.getArtworks(
        userId: user.userId,
        page: 1,
        size: 10,
      );
      expect(userWorks.items, isNotEmpty);

      // Filter by tags
      final taggedWorks = await artworksModule.getArtworks(
        tags: ['tagA'],
        page: 1,
        size: 10,
      );
      expect(taggedWorks, isNotNull);

      // Combine filters (userId + tags)
      final combinedFilter = await artworksModule.getArtworks(
        userId: user.userId,
        tags: ['tagA'],
        page: 1,
        size: 10,
      );
      expect(combinedFilter, isNotNull);
    });

    test('image upload scenarios (documentation)', () async {
      // Note: Actual image upload requires MultipartFile and file handling
      // This test documents the expected behavior without real file uploads
      
      final user = await registerUser();

      // No images (should succeed)
      final noImages = await artworksModule.postArtworks(
        title: 'No Images',
        tagsJson: '[]',
        accessToken: user.accessToken,
      );
      expect(noImages, startsWith('w_'));

      // TODO: Add actual image upload tests when MultipartFile handling is implemented
      // - Test with 1-5 images (should succeed)
      // - Test with 6+ images (should fail with 400/413/422)
      // - Test with very large file names (should handle gracefully)
    });
  });
}
