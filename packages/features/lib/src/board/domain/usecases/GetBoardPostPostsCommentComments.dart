import '../board_repo.dart';

final class GetBoardPostPostsCommentComments {
  final BoardRepo _repo;
  const GetBoardPostPostsCommentComments(this._repo);
  Future<List<({String commentId, String contents})>> call({required String postId})
    => _repo.getBoardPostPostsCommentComments(postId: postId);
}
