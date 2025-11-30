import '../auth_repo.dart';
import '../auth_entity.dart';

final class PostAuthRegister {
  final AuthRepo _repo;
  const PostAuthRegister(this._repo);
  Future<AuthEntity> call({required String email, required String password, String? name, String? role})
    => _repo.postAuthRegister(email: email, password: password, name: name, role: role);
}
