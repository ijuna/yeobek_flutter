// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/postArtistRestore.dart
import '../artist_repo.dart';

final class PostArtistRestore {
  final ArtistRepo _repo;

  const PostArtistRestore(this._repo);

  /// POST /artist/restore - 삭제된 아티스트 복원
  Future<void> call({required String instaId, int? rowVersion}) => _repo.postArtistRestore(
    instaId: instaId,
    rowVersion: rowVersion,
  );
}
