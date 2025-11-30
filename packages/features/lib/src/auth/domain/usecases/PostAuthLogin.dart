import '../auth_repo.dart';

final class PostAuthLogin {
  final AuthRepo _repo;
  const PostAuthLogin(this._repo);
  Future<({String accessToken, String refreshToken})> call({required String email, required String password})
    => _repo.postAuthLogin(email: email, password: password);
}
