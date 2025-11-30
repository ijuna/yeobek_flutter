import '../board_repo.dart';
import '../board_entity.dart';

final class PostBoardPostPosts {
  final BoardRepo _repo;
  const PostBoardPostPosts(this._repo);

  Future<BoardEntity> call({
    required String boardId,
    required String title,
    required String contents,
    String? authorName,
    String? accessToken,
  }) => _repo.postBoardPostPosts(
        boardId: boardId,
        title: title,
        contents: contents,
        authorName: authorName,
        accessToken: accessToken,
      );
}
