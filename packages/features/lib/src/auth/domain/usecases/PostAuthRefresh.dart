import '../auth_repo.dart';

final class PostAuthRefresh {
  final AuthRepo _repo;
  const PostAuthRefresh(this._repo);
  Future<({String accessToken, String refreshToken})> call({required String refreshToken})
    => _repo.postAuthRefresh(refreshToken: refreshToken);
}
