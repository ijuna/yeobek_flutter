// Error Schema Integration Tests
// Ported from test backend/api_py/test_error_schemas.py
// Tests common error response structures across all endpoints

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:features/features.dart';

void main() {
  late AuthModule authModule;
  late ArtworksModule artworksModule;
  late ArtistModule artistModule;
  
  String randomEmail(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp@test.example.com';
  }

  String uniqueInsta() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'dup_$timestamp';
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
    authModule = AuthModule.defaultClient();
    artworksModule = ArtworksModule.defaultClient();
    artistModule = ArtistModule.defaultClient();
  });

  group('Error Response Schema - 401 Unauthorized', () {
    test('401 errors have error and message fields', () async {
      try {
        await authModule.getAuthMe(accessToken: '');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
        
        // Verify error response structure
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          // Should have error or message field
          expect(
            body.containsKey('error') || body.containsKey('message'),
            isTrue,
            reason: '401 response should contain error or message field',
          );
        }
      }
    });
  });

  group('Error Response Schema - 404 Not Found', () {
    test('404 errors have error and message fields', () async {
      try {
        await artworksModule.getArtworksId(artworkId: 'w_nonexistent123');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
        
        // Verify error response structure
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          expect(
            body.containsKey('error') || body.containsKey('message'),
            isTrue,
            reason: '404 response should contain error or message field',
          );
        }
      }
    });
  });

  group('Error Response Schema - 409 Conflict', () {
    test('409 conflicts have error or detail fields', () async {
      final ownerToken = await registerOwner();
      final insta = uniqueInsta();

      // Create first artist
      await artistModule.postArtistCreate(
        name: 'Dup Test',
        instaId: insta,
        followers: 0,
        tags: ['a'],
        accessToken: ownerToken,
      );

      // Try to create duplicate
      try {
        await artistModule.postArtistCreate(
          name: 'Dup Test',
          instaId: insta,
          followers: 0,
          tags: ['a'],
          accessToken: ownerToken,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 409);
        
        // Verify error response structure
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          expect(
            body.containsKey('error') || body.containsKey('detail') || body.containsKey('message'),
            isTrue,
            reason: '409 response should contain error, detail, or message field',
          );
        }
      }
    });
  });

  group('Error Response Schema - 422 Validation', () {
    test('422 validation errors have error and details/message', () async {
      try {
        await authModule.postAuthRegister(
          email: 'invalid-email',
          password: 'Test123!@#',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 422));
        
        // Verify error response structure
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          expect(
            body.containsKey('error') || body.containsKey('message'),
            isTrue,
            reason: 'Validation error should contain error or message field',
          );
          
          // 422 may have details field
          if (e.response?.statusCode == 422) {
            // Details or message should be present
            expect(
              body.containsKey('details') || body.containsKey('message'),
              isTrue,
              reason: '422 response should contain details or message',
            );
          }
        }
      }
    });
  });

  group('Error Response Schema - Consistency', () {
    test('different endpoints return consistent error structures', () async {
      final errors = <Map<String, dynamic>>[];

      // Collect 401 from auth
      try {
        await authModule.getAuthMe(accessToken: '');
      } on DioException catch (e) {
        if (e.response?.data is Map<String, dynamic>) {
          errors.add(e.response!.data as Map<String, dynamic>);
        }
      }

      // Collect 404 from artworks
      try {
        await artworksModule.getArtworksId(artworkId: 'w_none');
      } on DioException catch (e) {
        if (e.response?.data is Map<String, dynamic>) {
          errors.add(e.response!.data as Map<String, dynamic>);
        }
      }

      // Collect 404 from artist
      try {
        await artistModule.getArtist(instaId: 'none');
      } on DioException catch (e) {
        if (e.response?.data is Map<String, dynamic>) {
          errors.add(e.response!.data as Map<String, dynamic>);
        }
      }

      // All errors should have at least error or message field
      for (final error in errors) {
        expect(
          error.containsKey('error') || error.containsKey('message'),
          isTrue,
          reason: 'All error responses should have consistent structure',
        );
      }
    });
  });
}
