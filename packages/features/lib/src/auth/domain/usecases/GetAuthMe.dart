import '../auth_repo.dart';
import '../auth_entity.dart';

final class GetAuthMe {
  final AuthRepo _repo;
  const GetAuthMe(this._repo);
  Future<AuthEntity> call({required String accessToken}) => _repo.getAuthMe(accessToken: accessToken);
}
