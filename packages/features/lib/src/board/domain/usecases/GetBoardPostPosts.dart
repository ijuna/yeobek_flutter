import '../board_repo.dart';
import '../board_entity.dart';

final class GetBoardPostPosts {
  final BoardRepo _repo;
  const GetBoardPostPosts(this._repo);
  Future<BoardEntity> call({required String postId}) => _repo.getBoardPostPosts(postId: postId);
}
