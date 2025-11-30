import '../board_repo.dart';

final class DeleteBoardPostPostsCommentComments {
  final BoardRepo _repo;
  const DeleteBoardPostPostsCommentComments(this._repo);
  Future<void> call({required String postId, required String commentId, String? accessToken})
    => _repo.deleteBoardPostPostsCommentComments(postId: postId, commentId: commentId, accessToken: accessToken);
}
