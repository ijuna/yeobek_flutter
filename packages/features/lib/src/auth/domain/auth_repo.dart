import 'auth_entity.dart';

abstract interface class AuthRepo {
  // POST /auth/register
  Future<AuthEntity> postAuthRegister({required String email, required String password, String? name, String? role});

  // POST /auth/login
  Future<({String accessToken, String refreshToken})> postAuthLogin({required String email, required String password});

  // GET /auth/me
  Future<AuthEntity> getAuthMe({required String accessToken});

  // POST /auth/refresh
  Future<({String accessToken, String refreshToken})> postAuthRefresh({required String refreshToken});
}
