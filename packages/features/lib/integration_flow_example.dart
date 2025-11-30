// Example integration flow showing Auth + Board usage
// 
// This demonstrates the typical workflow:
// 1. Register a user
// 2. Login and get tokens
// 3. Create a post
// 4. Like the post
// 5. Add a comment
// 6. Update the comment
// 7. List posts
// 8. Cleanup (delete comment, unlike, delete post)
//
// Run this from a Flutter app or test environment with:
//   await runIntegrationFlowExample();

import 'package:features/features.dart';

Future<void> runIntegrationFlowExample() async {
  // Initialize modules
  final authModule = AuthModule.defaultClient();
  final boardModule = BoardModule.defaultClient();

  // Test credentials
  final email = 'testuser_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'SecureP@ss123';
  final name = 'Test User';

  print('[1] Registering user: $email');
  final regResult = await authModule.postAuthRegister(
    email: email,
    password: password,
    name: name,
    role: 'user',
  );
  print('   ✓ Registered user: ${regResult.userId}');

  print('[2] Logging in...');
  final loginResult = await authModule.postAuthLogin(
    email: email,
    password: password,
  );
  final accessToken = loginResult.accessToken;
  final refreshToken = loginResult.refreshToken;
  print('   ✓ Access token: ${accessToken.substring(0, 20)}...');

  print('[3] Fetching user info...');
  final meResult = await authModule.getAuthMe(accessToken: accessToken);
  print('   ✓ User email: ${meResult.email}, name: ${meResult.name}');

  print('[4] Creating a board post...');
  final postEntity = await boardModule.postBoardPostPosts(
    boardId: 'general',
    title: 'Test Post Title',
    contents: 'This is a test post created via integration flow.',
    authorName: name,
    accessToken: accessToken,
  );
  final postId = postEntity.postId;
  print('   ✓ Created post: $postId, title: ${postEntity.title}');

  print('[5] Liking the post...');
  await boardModule.postBoardPostPostsLike(
    postId: postId,
    accessToken: accessToken,
  );
  print('   ✓ Post liked');

  print('[6] Adding a comment...');
  final commentId = await boardModule.postBoardPostPostsCommentComments(
    postId: postId,
    contents: 'Great post!',
    authorName: name,
    accessToken: accessToken,
  );
  print('   ✓ Comment created: $commentId');

  print('[7] Updating the comment...');
  final updatedComment = await boardModule.putBoardPostPostsCommentComments(
    postId: postId,
    commentId: commentId,
    contents: 'Updated: Really great post!',
    accessToken: accessToken,
  );
  print('   ✓ Comment updated: ${updatedComment.contents}');

  print('[8] Listing all posts...');
  final listResult = await boardModule.getBoardPostPostsList(
    boardId: 'general',
    page: 0,
    size: 10,
    sort: 'popular',
  );
  print('   ✓ Total posts: ${listResult.total}, fetched: ${listResult.posts.length}');
  for (final p in listResult.posts) {
    print('      - ${p.postId}: ${p.title} (likes: ${p.likesCount}, views: ${p.viewCount})');
  }

  print('[9] Fetching single post detail...');
  final detailPost = await boardModule.getBoardPostPosts(postId: postId);
  print('   ✓ Post detail: ${detailPost.title}, likes: ${detailPost.likesCount}');

  print('[10] Fetching comments for the post...');
  final comments = await boardModule.getBoardPostPostsCommentComments(postId: postId);
  print('   ✓ Comments count: ${comments.length}');
  for (final c in comments) {
    print('      - ${c.commentId}: ${c.contents}');
  }

  print('[11] Unliking the post...');
  await boardModule.deleteBoardPostPostsLike(
    postId: postId,
    userId: meResult.userId,
    accessToken: accessToken,
  );
  print('   ✓ Post unliked');

  print('[12] Deleting the comment...');
  await boardModule.deleteBoardPostPostsCommentComments(
    postId: postId,
    commentId: commentId,
    accessToken: accessToken,
  );
  print('   ✓ Comment deleted');

  print('[13] Deleting the post...');
  await boardModule.deleteBoardPostPosts(postId: postId, accessToken: accessToken);
  print('   ✓ Post deleted');

  print('[14] Refreshing token...');
  final refreshResult = await authModule.postAuthRefresh(refreshToken: refreshToken);
  print('   ✓ New access token: ${refreshResult.accessToken.substring(0, 20)}...');

  print('\n✅ Integration flow completed successfully!');
}
