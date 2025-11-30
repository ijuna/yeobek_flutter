import '../board_repo.dart';

final class PutBoardPostPostsCommentComments {
  final BoardRepo _repo;
  const PutBoardPostPostsCommentComments(this._repo);
  Future<({String commentId, String contents})> call({required String postId, required String commentId, required String contents, String? accessToken})
    => _repo.putBoardPostPostsCommentComments(postId: postId, commentId: commentId, contents: contents, accessToken: accessToken);
}
