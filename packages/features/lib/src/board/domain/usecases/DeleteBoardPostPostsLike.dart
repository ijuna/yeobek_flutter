import '../board_repo.dart';

final class DeleteBoardPostPostsLike {
  final BoardRepo _repo;
  const DeleteBoardPostPostsLike(this._repo);
  Future<void> call({required String postId, required String userId, String? accessToken})
    => _repo.deleteBoardPostPostsLike(postId: postId, userId: userId, accessToken: accessToken);
}
