import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/auth_repo.dart';
import '../domain/auth_entity.dart';
import 'remote/auth_api.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthApi _api;
  AuthRepoImpl({AuthApi? api}) : _api = api ?? AuthApi();

  @override
  Future<AuthEntity> postAuthRegister({required String email, required String password, String? name, String? role}) async {
    final resp = await _api.postRegister(email: email, password: password, name: name, role: role);
    final m = _normalize(resp);
    return AuthEntity(
      userId: (m['userId'] ?? m['id'] ?? '').toString(),
      email: (m['email'] ?? email).toString(),
      name: (m['name'])?.toString(),
      role: (m['role'])?.toString(),
      accessToken: (m['accessToken'])?.toString(),
      refreshToken: (m['refreshToken'])?.toString(),
    );
  }

  @override
  Future<({String accessToken, String refreshToken})> postAuthLogin({required String email, required String password}) async {
    final resp = await _api.postLogin(email: email, password: password);
    final m = _normalize(resp);
    return (
      accessToken: (m['accessToken'] ?? '').toString(),
      refreshToken: (m['refreshToken'] ?? '').toString(),
    );
  }

  @override
  Future<AuthEntity> getAuthMe({required String accessToken}) async {
    final resp = await _api.getMe(accessToken: accessToken);
    final m = _normalize(resp);
    return AuthEntity(
      userId: (m['userId'] ?? m['id'] ?? '').toString(),
      email: (m['email'] ?? '').toString(),
      name: (m['name'])?.toString(),
      role: (m['role'])?.toString(),
      accessToken: accessToken,
      refreshToken: null,
    );
  }

  @override
  Future<({String accessToken, String refreshToken})> postAuthRefresh({required String refreshToken}) async {
    final resp = await _api.postRefresh(refreshToken: refreshToken);
    final m = _normalize(resp);
    return (
      accessToken: (m['accessToken'] ?? '').toString(),
      refreshToken: (m['refreshToken'] ?? '').toString(),
    );
  }

  Map<String, dynamic> _normalize(Response resp) {
    final data = resp.data;
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try { return json.decode(data) as Map<String, dynamic>; } catch (_) {}
    }
    return <String, dynamic>{};
  }
}
