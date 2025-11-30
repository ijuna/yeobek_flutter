import '../board_repo.dart';

final class PostBoardPostPostsCommentComments {
  final BoardRepo _repo;
  const PostBoardPostPostsCommentComments(this._repo);
  Future<String> call({required String postId, required String contents, String? authorName, String? accessToken})
    => _repo.postBoardPostPostsCommentComments(postId: postId, contents: contents, authorName: authorName, accessToken: accessToken);
}
