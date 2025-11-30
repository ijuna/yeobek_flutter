// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/PostArtistRestore.dart
import '../artist_repo.dart';
import '../artist_entity.dart';

final class PostArtistRestore {
  final ArtistRepo _repo;

  const PostArtistRestore(this._repo);

  /// POST /artist/restore - 삭제된 아티스트 복원
  Future<ArtistEntity> call({
    required String instaId,
    int? revisionId,
    int? rowVersion,
    String? accessToken,
  }) => _repo.postArtistRestore(
        instaId: instaId,
        revisionId: revisionId,
        rowVersion: rowVersion,
        accessToken: accessToken,
      );
}
