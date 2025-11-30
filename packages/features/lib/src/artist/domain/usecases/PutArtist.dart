// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/PutArtist.dart
import '../artist_repo.dart';
import '../artist_entity.dart';

final class PutArtist {
  final ArtistRepo _repo;

  const PutArtist(this._repo);

  /// PUT /artist - 아티스트 정보 업데이트
  Future<ArtistEntity> call({
    required String instaId,
    String? name,
    int? followers,
    List<String>? tags,
    required int rowVersion,
    String? accessToken,
  }) => _repo.putArtist(
        instaId: instaId,
        name: name,
        followers: followers,
        tags: tags,
        rowVersion: rowVersion,
        accessToken: accessToken,
      );
}
