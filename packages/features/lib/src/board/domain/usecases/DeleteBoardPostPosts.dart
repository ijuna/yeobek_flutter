import '../board_repo.dart';

final class DeleteBoardPostPosts {
  final BoardRepo _repo;
  const DeleteBoardPostPosts(this._repo);

  Future<void> call({required String postId, String? accessToken})
    => _repo.deleteBoardPostPosts(postId: postId, accessToken: accessToken);
}
