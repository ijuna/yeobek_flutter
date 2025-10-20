// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/putArtist.dart
import '../artist_repo.dart';

final class PutArtist {
  final ArtistRepo _repo;

  const PutArtist(this._repo);

  /// PUT /artist - 아티스트 정보 업데이트
  Future<void> call({
    required String instaId,
    required bool force,
    required String name,
    required int followers,
    required List<String> tags,
    required int rowVersion,
  }) => _repo.putArtist(
    instaId: instaId,
    force: force,
    name: name,
    followers: followers,
    tags: tags,
    rowVersion: rowVersion,
  );
}
