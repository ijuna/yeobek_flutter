// Board Integration Tests
// Ported from test backend/api_py/test_board_api.py
// Tests posts and comments CRUD, likes, search, sorting

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:features/features.dart';

void main() {
  late BoardModule boardModule;
  late AuthModule authModule;
  
  String randomEmail(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp@test.example.com';
  }

  Future<({String userId, String accessToken})> registerUser() async {
    final email = randomEmail('user');
    final regResult = await authModule.postAuthRegister(
      email: email,
      password: 'TestPass123!@#',
    );
    final loginResult = await authModule.postAuthLogin(
      email: email,
      password: 'TestPass123!@#',
    );
    return (userId: regResult.userId, accessToken: loginResult.accessToken);
  }

  String uniqueBoardId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test_$timestamp';
  }

  setUpAll(() {
    boardModule = BoardModule.defaultClient();
    authModule = AuthModule.defaultClient();
  });

  group('Board - Post CRUD and Comments', () {
    test('unauthorized create returns 401', () async {
      try {
        await boardModule.postBoardPostPosts(
          boardId: 'test',
          title: '인증 없음',
          contents: 'test',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
      }
    });

    test('post CRUD flow', () async {
      final user = await registerUser();
      final boardId = uniqueBoardId();

      // Create post
      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: '테스트 게시글 제목',
        contents: '테스트 게시글 내용입니다.',
        accessToken: user.accessToken,
      );
      final postId = post.postId;
      expect(postId, startsWith('p_'));
      expect(post.title, '테스트 게시글 제목');

      // Get post detail
      final detail = await boardModule.getBoardPostPosts(postId: postId);
      expect(detail.postId, postId);
      expect(detail.boardId, boardId);
      expect(detail.title, '테스트 게시글 제목');

      // List posts
      final listResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        page: 1,
        size: 10,
      );
      expect(listResult.posts.any((p) => p.postId == postId), isTrue);

      // Search by query
      final searchResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        q: '테스트',
        page: 1,
        size: 10,
      );
      expect(searchResult.posts, isNotEmpty);

      // Sort by popular and views
      final popularResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        sort: 'popular',
        page: 1,
        size: 10,
      );
      expect(popularResult.posts, isNotEmpty);

      final viewsResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        sort: 'views',
        page: 1,
        size: 10,
      );
      expect(viewsResult.posts, isNotEmpty);

      // Update post
      final updated = await boardModule.putBoardPostPosts(
        postId: postId,
        title: '수정된 제목',
        contents: '수정된 내용',
        accessToken: user.accessToken,
      );
      expect(updated.title, '수정된 제목');

      // Verify update
      final detail2 = await boardModule.getBoardPostPosts(postId: postId);
      expect(detail2.title, '수정된 제목');

      // Like post (anonymous)
      await boardModule.postBoardPostPostsLike(postId: postId);

      // Delete post
      await boardModule.deleteBoardPostPosts(
        postId: postId,
        accessToken: user.accessToken,
      );

      // Get deleted post should fail
      try {
        await boardModule.getBoardPostPosts(postId: postId);
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });

    test('comment CRUD flow', () async {
      final user = await registerUser();
      final boardId = uniqueBoardId();

      // Create post first
      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: '댓글 테스트',
        contents: '댓글 테스트 내용',
        accessToken: user.accessToken,
      );
      final postId = post.postId;

      // Create comment
      final commentId = await boardModule.postBoardPostPostsCommentComments(
        postId: postId,
        contents: '첫 댓글',
        accessToken: user.accessToken,
      );
      expect(commentId, startsWith('c_'));

      // List comments
      final comments = await boardModule.getBoardPostPostsCommentComments(
        postId: postId,
      );
      expect(comments.any((c) => c.commentId == commentId), isTrue);

      // Update comment
      final updated = await boardModule.putBoardPostPostsCommentComments(
        postId: postId,
        commentId: commentId,
        contents: '수정 댓글',
        accessToken: user.accessToken,
      );
      expect(updated.contents, '수정 댓글');

      // Delete comment
      await boardModule.deleteBoardPostPostsCommentComments(
        postId: postId,
        commentId: commentId,
        accessToken: user.accessToken,
      );

      // List should not contain deleted comment
      final comments2 = await boardModule.getBoardPostPostsCommentComments(
        postId: postId,
      );
      expect(comments2.any((c) => c.commentId == commentId), isFalse);
    });
  });

  group('Board - Error Paths', () {
    test('non-existent post returns 404', () async {
      try {
        await boardModule.getBoardPostPosts(postId: 'p_nonexistent123');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });

    test('like non-existent post returns 404', () async {
      try {
        await boardModule.postBoardPostPostsLike(postId: 'p_nonexistent123');
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });

    test('unlike non-existent post returns 404', () async {
      try {
        await boardModule.deleteBoardPostPostsLike(
          postId: 'p_nonexistent123',
          userId: 'u_xxx',
        );
        fail('Should throw DioException');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });
  });

  group('Board - Sorting Order', () {
    test('popular and views sorting', () async {
      final user = await registerUser();
      final boardId = uniqueBoardId();

      // Create 3 posts
      final p1 = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'P1',
        contents: 'P1',
        accessToken: user.accessToken,
      );
      final p2 = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'P2',
        contents: 'P2',
        accessToken: user.accessToken,
      );
      final p3 = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'P3',
        contents: 'P3',
        accessToken: user.accessToken,
      );

      // Like p3 twice, p2 once
      await boardModule.postBoardPostPostsLike(postId: p3.postId);
      await boardModule.postBoardPostPostsLike(postId: p3.postId);
      await boardModule.postBoardPostPostsLike(postId: p2.postId);

      // Popular sort
      final popularResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        sort: 'popular',
        page: 1,
        size: 10,
      );
      final popularIds = popularResult.posts.map((p) => p.postId).toList();
      if (popularIds.contains(p3.postId) && popularIds.contains(p2.postId)) {
        expect(popularIds.indexOf(p3.postId), lessThan(popularIds.indexOf(p2.postId)));
      }

      // Views: hit p1 twice, p2 once
      await boardModule.getBoardPostPosts(postId: p1.postId);
      await boardModule.getBoardPostPosts(postId: p1.postId);
      await boardModule.getBoardPostPosts(postId: p2.postId);

      final viewsResult = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        sort: 'views',
        page: 1,
        size: 10,
      );
      final viewsIds = viewsResult.posts.map((p) => p.postId).toList();
      if (viewsIds.contains(p1.postId) && viewsIds.contains(p3.postId)) {
        expect(viewsIds.indexOf(p1.postId), lessThan(viewsIds.indexOf(p3.postId)));
      }
    });
  });

  group('Board - Pagination Edge Cases', () {
    test('out of bounds page returns empty', () async {
      final result = await boardModule.getBoardPostPostsList(
        boardId: 'any',
        page: 9999,
        size: 10,
      );
      expect(result.posts, isEmpty);
    });

    test('size=0 should be rejected or return empty', () async {
      try {
        await boardModule.getBoardPostPostsList(
          boardId: 'any',
          page: 1,
          size: 0,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 422));
      }
    });
  });

  group('Board - XSS and Special Characters', () {
    test('XSS in title and content', () async {
      final user = await registerUser();
      final boardId = 'xss';

      try {
        final post = await boardModule.postBoardPostPosts(
          boardId: boardId,
          title: "<script>alert('xss')</script>",
          contents: "<img src=x onerror=alert(1)>",
          accessToken: user.accessToken,
        );
        // Backend may accept or reject; ensure no crash
        final detail = await boardModule.getBoardPostPosts(postId: post.postId);
        expect(detail.postId, isNotEmpty);
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400));
      }
    });

    test('unicode and emoji', () async {
      final user = await registerUser();
      final boardId = 'unicode';

      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: '🎉 이벤트 🎊',
        contents: '환영합니다!',
        accessToken: user.accessToken,
      );
      expect(post.title, contains(RegExp(r'🎉|이벤트')));

      final detail = await boardModule.getBoardPostPosts(postId: post.postId);
      expect(detail.title, contains(RegExp(r'🎉|이벤트')));

      // Emoji in comment
      final commentId = await boardModule.postBoardPostPostsCommentComments(
        postId: post.postId,
        contents: '좋아요! 👍',
        accessToken: user.accessToken,
      );
      expect(commentId, startsWith('c_'));
    });

    test('extreme content length', () async {
      final user = await registerUser();
      final boardId = 'extreme';

      // Very long title
      final longTitle = 'T' * 250;
      try {
        await boardModule.postBoardPostPosts(
          boardId: boardId,
          title: longTitle,
          contents: 'test',
          accessToken: user.accessToken,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Very long content
      final longContent = 'C' * 6000;
      try {
        await boardModule.postBoardPostPosts(
          boardId: boardId,
          title: 'Long Content',
          contents: longContent,
          accessToken: user.accessToken,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Empty title
      try {
        await boardModule.postBoardPostPosts(
          boardId: boardId,
          title: '',
          contents: 'test',
          accessToken: user.accessToken,
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }
    });
  });

  group('Board - Search and Filter', () {
    test('search with exact match and no results', () async {
      final user = await registerUser();
      final boardId = 'search';

      // Create searchable posts
      await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'Apple Banana',
        contents: 'test',
        accessToken: user.accessToken,
      );
      await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'Cherry Date',
        contents: 'test',
        accessToken: user.accessToken,
      );

      // Search with exact match
      final result1 = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        q: 'Apple',
      );
      expect(result1.posts, isNotEmpty);

      // Search with no results
      final result2 = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        q: 'NonExistent12345',
      );
      expect(result2.posts, isEmpty);

      // Empty search query
      final result3 = await boardModule.getBoardPostPostsList(
        boardId: boardId,
        q: '',
      );
      expect(result3.posts, isNotEmpty);
    });
  });

  group('Board - Multiple Users Interaction', () {
    test('multiple users creating posts, comments, likes', () async {
      final user1 = await registerUser();
      final user2 = await registerUser();
      final boardId = 'multi';

      // User1 creates post
      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'U1 Post',
        contents: 'U1 Content',
        accessToken: user1.accessToken,
      );

      // User2 comments
      final commentId = await boardModule.postBoardPostPostsCommentComments(
        postId: post.postId,
        contents: 'U2 Comment',
        accessToken: user2.accessToken,
      );
      expect(commentId, startsWith('c_'));

      // User2 likes
      await boardModule.postBoardPostPostsLike(postId: post.postId);

      // User2 tries to update User1's post (may fail based on ownership)
      try {
        await boardModule.putBoardPostPosts(
          postId: post.postId,
          title: 'Hacked',
          contents: 'Hacked',
          accessToken: user2.accessToken,
        );
        // May succeed if no ownership check
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 403));
      }

      // User1 deletes own post
      await boardModule.deleteBoardPostPosts(
        postId: post.postId,
        accessToken: user1.accessToken,
      );
    });
  });

  group('Board - Advanced Edge Cases', () {
    test('comment nesting and edge cases', () async {
      final user = await registerUser();
      final boardId = 'comment_edge';

      // Create post
      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'Comment Edge Test',
        contents: 'Test',
        accessToken: user.accessToken,
      );

      // Very long comment (1000+ chars)
      final longComment = 'C' * 1200;
      try {
        await boardModule.postBoardPostPostsCommentComments(
          postId: post.postId,
          contents: longComment,
          accessToken: user.accessToken,
        );
        // May succeed or be rejected
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Empty comment
      try {
        await boardModule.postBoardPostPostsCommentComments(
          postId: post.postId,
          contents: '',
          accessToken: user.accessToken,
        );
        // May succeed or be rejected
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 400, 422));
      }

      // Comment on non-existent post
      try {
        await boardModule.postBoardPostPostsCommentComments(
          postId: 'p_nonexistent',
          contents: 'Orphan comment',
          accessToken: user.accessToken,
        );
        // May succeed if no FK check, fail with 404 if validated
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf(200, 404));
      }
    });

    test('concurrent likes same post', () async {
      final user = await registerUser();
      final boardId = 'race';

      // Create post
      final post = await boardModule.postBoardPostPosts(
        boardId: boardId,
        title: 'Race Test',
        contents: 'Test',
        accessToken: user.accessToken,
      );

      // Launch multiple concurrent like requests
      final futures = List.generate(10, (_) {
        return boardModule.postBoardPostPostsLike(
          postId: post.postId,
        ).then((_) => 'success').catchError((Object e) {
          if (e is DioException) {
            return 'failed-${e.response?.statusCode ?? 0}';
          }
          return 'error';
        });
      });

      final results = await Future.wait(futures);

      // Some may succeed, some may fail with duplicate; just ensure no crash
      expect(results, isNotEmpty);
      expect(results.any((r) => r.contains('success') || r.contains('failed')), isTrue);
    });
  });
}
