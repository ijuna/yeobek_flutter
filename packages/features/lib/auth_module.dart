import 'package:dio/dio.dart';
import 'package:network/network.dart';

import 'src/auth/domain/auth_repo.dart';
import 'src/auth/domain/auth_entity.dart';
import 'src/auth/domain/usecases/PostAuthRegister.dart';
import 'src/auth/domain/usecases/PostAuthLogin.dart';
import 'src/auth/domain/usecases/GetAuthMe.dart';
import 'src/auth/domain/usecases/PostAuthRefresh.dart';
import 'src/auth/data/auth_repo_impl.dart';
import 'src/auth/data/remote/auth_api.dart';

// 외부 사용을 위해 API export
export 'src/auth/data/remote/auth_api.dart';

final class AuthModule {
  final AuthRepo repo;

  final PostAuthRegister postAuthRegister;
  final PostAuthLogin postAuthLogin;
  final GetAuthMe getAuthMe;
  final PostAuthRefresh postAuthRefresh;

  const AuthModule({
    required this.repo,
    required this.postAuthRegister,
    required this.postAuthLogin,
    required this.getAuthMe,
    required this.postAuthRefresh,
  });

  factory AuthModule.fromRepo(AuthRepo repo) {
    return AuthModule(
      repo: repo,
      postAuthRegister: PostAuthRegister(repo),
      postAuthLogin: PostAuthLogin(repo),
      getAuthMe: GetAuthMe(repo),
      postAuthRefresh: PostAuthRefresh(repo),
    );
  }

  factory AuthModule.fromApi(AuthApi api) => AuthModule.fromRepo(AuthRepoImpl(api: api));

  factory AuthModule.fromDio(Dio dio) => AuthModule.fromApi(AuthApi(dio));

  factory AuthModule.defaultClient() => AuthModule.fromDio(Network.dio);
}
