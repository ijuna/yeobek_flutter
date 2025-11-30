import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/board_repo.dart';
import '../domain/board_entity.dart';
import 'remote/board_api.dart';

class BoardRepoImpl implements BoardRepo {
  final BoardApi _api;
  BoardRepoImpl({BoardApi? api}) : _api = api ?? BoardApi();

  @override
  Future<BoardEntity> postBoardPostPosts({
    required String boardId,
    required String title,
    required String contents,
    String? authorName,
    String? accessToken,
  }) async {
    final resp = await _api.postPosts(
      boardId: boardId,
      title: title,
      content: contents,
      authorName: authorName,
      accessToken: accessToken,
    );
    final m = _normalize(resp);
    return BoardEntity(
      postId: m['postId']?.toString() ?? '',
      title: m['title']?.toString() ?? title,
      contents: (m['content'] ?? m['contents'])?.toString(),
      boardType: _asInt(m['boardType']),
      boardId: m['boardId']?.toString(),
      userId: m['userId']?.toString(),
      viewCount: _asInt(m['viewCount']),
      likesCount: _asInt(m['likesCount']),
    );
  }

  @override
  Future<BoardEntity> getBoardPostPosts({required String postId}) async {
    final resp = await _api.getPost(postId: postId);
    final m = _normalize(resp);
    return BoardEntity(
      postId: m['postId']?.toString() ?? postId,
      title: m['title']?.toString() ?? '',
      contents: (m['content'] ?? m['contents'])?.toString(),
      boardId: m['boardId']?.toString(),
      userId: m['userId']?.toString(),
      viewCount: _asInt(m['viewCount']),
      likesCount: _asInt(m['likesCount']),
    );
  }

  @override
  Future<({List<BoardEntity> posts, int? total})> getBoardPostPostsList({
    String? boardId,
    int? page,
    int? size,
    String? sort,
    String? q,
  }) async {
    final resp = await _api.getPosts(boardId: boardId, page: page, size: size, sort: sort, q: q);
    final m = _normalize(resp);
    final list = (m['items'] as List? ?? m['posts'] as List? ?? const []).cast<dynamic>();
    final posts = list.map((e){
      final mm = (e is Map) ? Map<String, dynamic>.from(e as Map) : <String, dynamic>{};
      return BoardEntity(
        postId: mm['postId']?.toString() ?? '',
        title: mm['title']?.toString() ?? '',
        contents: (mm['content'] ?? mm['contents'])?.toString(),
        boardId: mm['boardId']?.toString(),
        userId: mm['userId']?.toString(),
        viewCount: _asInt(mm['viewCount']),
        likesCount: _asInt(mm['likesCount']),
      );
    }).toList();
    final total = _asInt(m['total']);
    return (posts: posts, total: total);
  }

  @override
  Future<BoardEntity> putBoardPostPosts({
    required String postId,
    required String title,
    required String contents,
    String? accessToken,
  }) async {
    final resp = await _api.patchPost(postId: postId, title: title, content: contents, accessToken: accessToken);
    final m = _normalize(resp);
    return BoardEntity(
      postId: m['postId']?.toString() ?? postId,
      title: m['title']?.toString() ?? title,
      contents: (m['content'] ?? m['contents'])?.toString() ?? contents,
      boardId: m['boardId']?.toString(),
      userId: m['userId']?.toString(),
      viewCount: _asInt(m['viewCount']),
      likesCount: _asInt(m['likesCount']),
    );
  }

  @override
  Future<void> postBoardPostPostsLike({required String postId, String? accessToken})
    => _api.putLike(postId: postId, accessToken: accessToken).then((_){});

  @override
  Future<void> deleteBoardPostPostsLike({required String postId, required String userId, String? accessToken})
    => _api.deleteLike(postId: postId, userId: userId, accessToken: accessToken).then((_){});

  @override
  Future<String> postBoardPostPostsCommentComments({
    required String postId,
    required String contents,
    String? authorName,
    String? accessToken,
  }) async {
    final resp = await _api.postComment(postId: postId, contents: contents, authorName: authorName, accessToken: accessToken);
    final m = _normalize(resp);
    return m['commentId']?.toString() ?? '';
  }

  @override
  Future<List<({String commentId, String contents})>> getBoardPostPostsCommentComments({required String postId}) async {
    final resp = await _api.getComments(postId: postId);
    final m = _normalize(resp);
    final list = (m['items'] as List? ?? m['comments'] as List? ?? const []).cast<dynamic>();
    return list.map((e){
      final mm = (e is Map) ? Map<String, dynamic>.from(e as Map) : <String, dynamic>{};
      final id = (mm['commentId'] ?? mm['id'] ?? '').toString();
      final cont = (mm['contents'] ?? mm['content'] ?? '').toString();
      return (commentId: id, contents: cont);
    }).toList();
  }

  @override
  Future<({String commentId, String contents})> putBoardPostPostsCommentComments({
    required String postId,
    required String commentId,
    required String contents,
    String? accessToken,
  }) async {
    final resp = await _api.patchComment(commentId: commentId, contents: contents, accessToken: accessToken);
    final m = _normalize(resp);
    return (commentId: m['commentId']?.toString() ?? commentId, contents: (m['contents'] ?? m['content'])?.toString() ?? contents);
  }

  @override
  Future<void> deleteBoardPostPostsCommentComments({
    required String postId,
    required String commentId,
    String? accessToken,
  }) => _api.deleteComment(commentId: commentId, accessToken: accessToken).then((_){});

  @override
  Future<void> deleteBoardPostPosts({required String postId, String? accessToken})
    => _api.deletePost(postId: postId, accessToken: accessToken).then((_){});

  Map<String, dynamic> _normalize(Response resp) {
    final data = resp.data;
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try { return json.decode(data) as Map<String, dynamic>; } catch (_) {}
    }
    return <String, dynamic>{};
  }

  int? _asInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    final s = v.toString();
    return int.tryParse(s);
  }
}
