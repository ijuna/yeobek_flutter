import '../board_repo.dart';

final class PostBoardPostPostsLike {
  final BoardRepo _repo;
  const PostBoardPostPostsLike(this._repo);
  Future<void> call({required String postId, String? accessToken}) => _repo.postBoardPostPostsLike(postId: postId, accessToken: accessToken);
}
