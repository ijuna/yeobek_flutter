import '../../post/domain/post_entity.dart';

abstract interface class PostRepository {
  Future<List<PostEntity>> fetch();
}
