import 'package:dio/dio.dart';
import 'package:network/network.dart';

import 'src/board/domain/board_repo.dart';
import 'src/board/data/board_repo_impl.dart';
import 'src/board/data/remote/board_api.dart';
import 'src/board/domain/usecases/PostBoardPostPosts.dart';
import 'src/board/domain/usecases/GetBoardPostPosts.dart';
import 'src/board/domain/usecases/GetBoardPostPostsList.dart';
import 'src/board/domain/usecases/PutBoardPostPosts.dart';
import 'src/board/domain/usecases/PostBoardPostPostsLike.dart';
import 'src/board/domain/usecases/DeleteBoardPostPostsLike.dart';
import 'src/board/domain/usecases/PostBoardPostPostsCommentComments.dart';
import 'src/board/domain/usecases/GetBoardPostPostsCommentComments.dart';
import 'src/board/domain/usecases/PutBoardPostPostsCommentComments.dart';
import 'src/board/domain/usecases/DeleteBoardPostPostsCommentComments.dart';
import 'src/board/domain/usecases/DeleteBoardPostPosts.dart';

// API export for external use/testing
export 'src/board/data/remote/board_api.dart';

final class BoardModule {
  final BoardRepo repo;

  final PostBoardPostPosts postBoardPostPosts;
  final GetBoardPostPosts getBoardPostPosts;
  final GetBoardPostPostsList getBoardPostPostsList;
  final PutBoardPostPosts putBoardPostPosts;
  final PostBoardPostPostsLike postBoardPostPostsLike;
  final DeleteBoardPostPostsLike deleteBoardPostPostsLike;
  final PostBoardPostPostsCommentComments postBoardPostPostsCommentComments;
  final GetBoardPostPostsCommentComments getBoardPostPostsCommentComments;
  final PutBoardPostPostsCommentComments putBoardPostPostsCommentComments;
  final DeleteBoardPostPostsCommentComments deleteBoardPostPostsCommentComments;
  final DeleteBoardPostPosts deleteBoardPostPosts;

  const BoardModule({
    required this.repo,
    required this.postBoardPostPosts,
    required this.getBoardPostPosts,
    required this.getBoardPostPostsList,
    required this.putBoardPostPosts,
    required this.postBoardPostPostsLike,
    required this.deleteBoardPostPostsLike,
    required this.postBoardPostPostsCommentComments,
    required this.getBoardPostPostsCommentComments,
    required this.putBoardPostPostsCommentComments,
    required this.deleteBoardPostPostsCommentComments,
    required this.deleteBoardPostPosts,
  });

  factory BoardModule.fromRepo(BoardRepo repo) {
    return BoardModule(
      repo: repo,
      postBoardPostPosts: PostBoardPostPosts(repo),
      getBoardPostPosts: GetBoardPostPosts(repo),
      getBoardPostPostsList: GetBoardPostPostsList(repo),
      putBoardPostPosts: PutBoardPostPosts(repo),
      postBoardPostPostsLike: PostBoardPostPostsLike(repo),
      deleteBoardPostPostsLike: DeleteBoardPostPostsLike(repo),
      postBoardPostPostsCommentComments: PostBoardPostPostsCommentComments(repo),
      getBoardPostPostsCommentComments: GetBoardPostPostsCommentComments(repo),
      putBoardPostPostsCommentComments: PutBoardPostPostsCommentComments(repo),
      deleteBoardPostPostsCommentComments: DeleteBoardPostPostsCommentComments(repo),
      deleteBoardPostPosts: DeleteBoardPostPosts(repo),
    );
  }

  factory BoardModule.fromApi(BoardApi api) => BoardModule.fromRepo(BoardRepoImpl(api: api));

  factory BoardModule.fromDio(Dio dio) => BoardModule.fromApi(BoardApi(dio));

  factory BoardModule.defaultClient() => BoardModule.fromDio(Network.dio);
}
