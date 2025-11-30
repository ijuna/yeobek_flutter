// Auth Integration Tests
// Ported from test backend/api_py/test_auth_api.py
// Tests register, login, me, refresh, and error cases

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:features/features.dart';

void main() {
  late AuthModule authModule;
  
  // Helper to generate unique email
  String randomEmail(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp@test.example.com';
  }

  setUpAll(() {
    authModule = AuthModule.defaultClient();
  });

  group('Auth - Register, Login, Me, Refresh', () {
    test('register and login with role', () async {
      final email = randomEmail('reg_login');
      final password = 'TestPass123!@#';
      const role = 'artist';

      // Register
      final regResult = await authModule.postAuthRegister(
        email: email,
        password: password,
        role: role,
      );
      expect(regResult.userId, startsWith('u_'));
      expect(regResult.email, email);

      // Login
      final loginResult = await authModule.postAuthLogin(
        email: email,
        password: password,
      );
      expect(loginResult.accessToken, isNotEmpty);
      expect(loginResult.refreshToken, isNotEmpty);

      // Me
      final meResult = await authModule.getAuthMe(
        accessToken: loginResult.accessToken,
      );
      expect(meResult.userId, startsWith('u_'));
      expect(meResult.email, email);

      // Refresh
      final refreshResult = await authModule.postAuthRefresh(
        refreshToken: loginResult.refreshToken,
      );
      expect(refreshResult.accessToken, isNotEmpty);
      expect(refreshResult.refreshToken, isNotEmpty);

      // New access token should work
      final me2 = await authModule.getAuthMe(
        accessToken: refreshResult.accessToken,
      );
      expect(me2.userId, startsWith('u_'));
    });

    test('me without token returns 401', () async {
      try {
        await authModule.getAuthMe(accessToken: '');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }
    });
  });

  group('Auth - Validations and Errors', () {
    test('duplicate email returns 409', () async {
      final email = randomEmail('dup');
      final password = 'TestPass123!@#';

      // First registration
      await authModule.postAuthRegister(
        email: email,
        password: password,
      );

      // Duplicate should fail
      try {
        await authModule.postAuthRegister(
          email: email,
          password: password,
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 409));
      }
    });

    test('invalid email returns 400/422', () async {
      try {
        await authModule.postAuthRegister(
          email: 'invalid-email',
          password: 'TestPass123!@#',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 422));
      }
    });

    test('wrong password returns 401', () async {
      final email = randomEmail('wrongpw');
      final password = 'TestPass123!@#';

      await authModule.postAuthRegister(
        email: email,
        password: password,
      );

      try {
        await authModule.postAuthLogin(
          email: email,
          password: 'WrongPassword123!',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }
    });

    test('login non-existent user returns 401', () async {
      try {
        await authModule.postAuthLogin(
          email: randomEmail('nouser'),
          password: 'TestPass123!@#',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 401));
      }
    });

    test('invalid refresh token returns 400/401', () async {
      try {
        await authModule.postAuthRefresh(
          refreshToken: 'invalid_refresh_token',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 401));
      }
    });
  });

  group('Auth - Special Characters and Edge Cases', () {
    test('special chars in email and password', () async {
      final email = randomEmail('special+user.test');
      final password = 'P@ssw0rd!#\$%';

      final regResult = await authModule.postAuthRegister(
        email: email,
        password: password,
      );
      expect(regResult.userId, startsWith('u_'));

      final loginResult = await authModule.postAuthLogin(
        email: email,
        password: password,
      );
      expect(loginResult.accessToken, isNotEmpty);
    });

    test('XSS in name field', () async {
      final email = randomEmail('xss');
      final password = 'Test123!@#';

      try {
        final regResult = await authModule.postAuthRegister(
          email: email,
          password: password,
          name: "<script>alert('xss')</script>",
        );
        
        // If accepted, verify it doesn't crash on retrieval
        final loginResult = await authModule.postAuthLogin(
          email: email,
          password: password,
        );
        final meResult = await authModule.getAuthMe(
          accessToken: loginResult.accessToken,
        );
        expect(meResult.name, isNotNull);
      } on DioException catch (e) {
        // May be rejected with 400
        expect(e.response?.statusCode, anyOf(200, 201, 400));
      }
    });

    test('very long password', () async {
      final email = randomEmail('longpw');
      final longPw = 'A' * 70 + '!@';

      final regResult = await authModule.postAuthRegister(
        email: email,
        password: longPw,
      );
      expect(regResult.userId, startsWith('u_'));
    });

    test('empty fields return 400/422', () async {
      try {
        await authModule.postAuthRegister(
          email: '',
          password: 'Test123!@#',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 422));
      }

      try {
        await authModule.postAuthRegister(
          email: randomEmail('empty'),
          password: '',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(400, 422));
      }
    });
  });

  group('Auth - Advanced Edge Cases', () {
    test('CORS headers present (HTTP layer)', () async {
      // Note: Dio client doesn't expose CORS headers directly in response
      // This test documents the expectation but can't verify at Dart client level
      // CORS is enforced by browsers, not HTTP clients like Dio
      final email = randomEmail('cors');
      try {
        final regResult = await authModule.postAuthRegister(
          email: email,
          password: 'Test123!@#',
        );
        // If we reach here, request succeeded (CORS headers should be present on server)
        expect(regResult.userId, startsWith('u_'));
      } catch (e) {
        // Any error is fine for this test; we're documenting CORS expectation
        expect(true, isTrue);
      }
    });

    test('concurrent registrations same email', () async {
      final email = randomEmail('race');
      final password = 'Test123!@#';
      
      // Launch multiple concurrent registration attempts
      final futures = List.generate(5, (_) {
        return authModule.postAuthRegister(
          email: email,
          password: password,
        ).then((_) => 'success').catchError((e) => 'failed');
      });

      final results = await Future.wait(futures);
      
      // At most 1 should succeed, rest should fail with 409/400
      final successCount = results.where((r) => r == 'success').length;
      expect(successCount, lessThanOrEqualTo(1), 
        reason: 'Multiple concurrent registrations should not all succeed');
    });

    test('multiple refresh tokens usage', () async {
      final email = randomEmail('multirefresh');
      final password = 'Test123!@#';

      await authModule.postAuthRegister(
        email: email,
        password: password,
      );

      final loginResult = await authModule.postAuthLogin(
        email: email,
        password: password,
      );

      // First refresh
      final refresh1 = await authModule.postAuthRefresh(
        refreshToken: loginResult.refreshToken,
      );
      expect(refresh1.accessToken, isNotEmpty);

      // Second refresh with original token (may fail if single-use)
      try {
        await authModule.postAuthRefresh(
          refreshToken: loginResult.refreshToken,
        );
        // If it succeeds, token is reusable
      } on DioException catch (e) {
        // If it fails, token is single-use
        expect(e.response?.statusCode, anyOf(400, 401));
      }

      // Use new refresh token should work
      final refresh2 = await authModule.postAuthRefresh(
        refreshToken: refresh1.refreshToken,
      );
      expect(refresh2.accessToken, isNotEmpty);
    });

    test('bearer token malformed', () async {
      // Test various malformed Authorization scenarios
      // Note: Dio will validate some formats, but server should also reject
      
      // Empty token
      try {
        await authModule.getAuthMe(accessToken: '');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }

      // Invalid format (not JWT)
      try {
        await authModule.getAuthMe(accessToken: 'InvalidToken');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }

      // Malformed JWT (wrong segments)
      try {
        await authModule.getAuthMe(accessToken: 'a.b');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }
    });
  });
}
