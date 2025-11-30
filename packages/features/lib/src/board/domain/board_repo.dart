// tattoo_frontend/packages/features/lib/src/board/domain/board_repo.dart
import 'board_entity.dart';

abstract interface class BoardRepo {
  // POST /board/post
  Future<BoardEntity> postBoardPostPosts({
    required String boardId,
    required String title,
    required String contents,
    String? authorName,
    String? accessToken,
  });

  // GET /board/post/{postId}
  Future<BoardEntity> getBoardPostPosts({required String postId});

  // GET /board/post?boardId=...&page=...&size=...&sort=popular|views&q=...
  Future<({List<BoardEntity> posts, int? total})> getBoardPostPostsList({
    String? boardId,
    int? page,
    int? size,
    String? sort,
    String? q,
  });

  // PATCH /board/post/{postId}
  Future<BoardEntity> putBoardPostPosts({
    required String postId,
    required String title,
    required String contents,
    String? accessToken,
  });

  // PUT /board/post/{postId}/like
  Future<void> postBoardPostPostsLike({required String postId, String? accessToken});

  // DELETE /board/post/{postId}/like?userId=...
  Future<void> deleteBoardPostPostsLike({required String postId, required String userId, String? accessToken});

  // POST /board/comment?postId=...
  Future<String> postBoardPostPostsCommentComments({
    required String postId,
    required String contents,
    String? authorName,
    String? accessToken,
  });

  // GET /board/comment?postId=...
  Future<List<({String commentId, String contents})>> getBoardPostPostsCommentComments({required String postId});

  // PATCH /board/comment/{commentId}
  Future<({String commentId, String contents})> putBoardPostPostsCommentComments({
    required String postId,
    required String commentId,
    required String contents,
    String? accessToken,
  });

  // DELETE /board/comment/{commentId}
  Future<void> deleteBoardPostPostsCommentComments({
    required String postId,
    required String commentId,
    String? accessToken,
  });

  // DELETE /board/post/{postId}
  Future<void> deleteBoardPostPosts({required String postId, String? accessToken});
}
