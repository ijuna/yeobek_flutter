class BoardEntity {
  final String postId;
  final String title;
  final String? contents;
  final int? boardType;
  final String? boardId;
  final String? userId;
  final int? viewCount;
  final int? likesCount;
  const BoardEntity({
    required this.postId,
    required this.title,
    this.contents,
    this.boardType,
    this.boardId,
    this.userId,
    this.viewCount,
    this.likesCount,
  });
}
