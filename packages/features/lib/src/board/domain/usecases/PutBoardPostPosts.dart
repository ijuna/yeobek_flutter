import '../board_repo.dart';
import '../board_entity.dart';

final class PutBoardPostPosts {
  final BoardRepo _repo;
  const PutBoardPostPosts(this._repo);

  Future<BoardEntity> call({required String postId, required String title, required String contents, String? accessToken})
    => _repo.putBoardPostPosts(postId: postId, title: title, contents: contents, accessToken: accessToken);
}
