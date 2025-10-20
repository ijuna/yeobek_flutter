// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/getArtistExists.dart
import '../artist_repo.dart';

final class GetArtistExists {
  final ArtistRepo _repo;

  const GetArtistExists(this._repo);

  /// GET /artist/exists - 아티스트 존재 여부 확인
  Future<({bool exists, int? id})> call({required String instaId}) => _repo.getArtistExists(
    instaId: instaId,
  );
}
