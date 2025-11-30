import 'package:dio/dio.dart';
import 'package:network/network.dart';

class AuthApi {
  final Dio _dio;
  AuthApi([Dio? dio]) : _dio = dio ?? Network.dio;

  Future<Response<dynamic>> postRegister({required String email, required String password, String? name, String? role}) {
    return _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
    });
  }

  Future<Response<dynamic>> postLogin({required String email, required String password}) {
    return _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response<dynamic>> getMe({required String accessToken}) {
    return _dio.get('/auth/me', options: Options(headers: {
      'Authorization': 'Bearer $accessToken',
    }));
  }

  Future<Response<dynamic>> postRefresh({required String refreshToken}) {
    return _dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
  }
}
