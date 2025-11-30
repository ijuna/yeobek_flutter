// tattoo_frontend/packages/features/lib/features.dart
// artist (presentation 제거됨: 배럴에서 제외)
export 'src/artist/domain/artist_entity.dart';
export 'src/artist/domain/artist_repo.dart';
export 'src/artist/domain/usecases/GetArtistPing.dart';
export 'src/artist/domain/usecases/PostArtistCreate.dart';
export 'src/artist/domain/usecases/GetArtist.dart';
export 'src/artist/domain/usecases/PutArtist.dart';
export 'src/artist/domain/usecases/DeleteArtist.dart';
export 'src/artist/domain/usecases/GetArtistList.dart';
export 'src/artist/domain/usecases/GetArtistExists.dart';
export 'src/artist/domain/usecases/PostArtistRestore.dart';
export 'src/artist/domain/usecases/GetArtistHistory.dart';
export 'artist_module.dart';

// artworks (presentation 제거됨: 배럴에서 제외)
export 'src/artworks/domain/artworks_entity.dart';
export 'src/artworks/domain/artworks_repo.dart';
export 'src/artworks/domain/usecases/PostArtworks.dart';
export 'src/artworks/domain/usecases/GetArtworksId.dart';
export 'src/artworks/domain/usecases/GetArtworks.dart';
export 'src/artworks/domain/usecases/PatchArtworksId.dart';
export 'src/artworks/domain/usecases/PutArtworksIdLike.dart';
export 'src/artworks/domain/usecases/DeleteArtworksIdLike.dart';
export 'src/artworks/domain/usecases/DeleteArtworksId.dart';

// board (presentation 제거됨: 배럴에서 제외)
export 'src/board/domain/board_entity.dart';
export 'src/board/domain/board_repo.dart';
export 'src/board/domain/usecases/PostBoardPostPosts.dart';
export 'src/board/domain/usecases/GetBoardPostPosts.dart';
export 'src/board/domain/usecases/GetBoardPostPostsList.dart';
export 'src/board/domain/usecases/PutBoardPostPosts.dart';
export 'src/board/domain/usecases/PostBoardPostPostsLike.dart';
export 'src/board/domain/usecases/DeleteBoardPostPostsLike.dart';
export 'src/board/domain/usecases/PostBoardPostPostsCommentComments.dart';
export 'src/board/domain/usecases/GetBoardPostPostsCommentComments.dart';
export 'src/board/domain/usecases/PutBoardPostPostsCommentComments.dart';
export 'src/board/domain/usecases/DeleteBoardPostPostsCommentComments.dart';
export 'src/board/domain/usecases/DeleteBoardPostPosts.dart';
export 'board_module.dart';

// auth
export 'src/auth/domain/auth_entity.dart';
export 'src/auth/domain/auth_repo.dart';
export 'src/auth/domain/usecases/PostAuthRegister.dart';
export 'src/auth/domain/usecases/PostAuthLogin.dart';
export 'src/auth/domain/usecases/GetAuthMe.dart';
export 'src/auth/domain/usecases/PostAuthRefresh.dart';
export 'auth_module.dart';

// convenience module for artworks
export 'artworks_module.dart';
