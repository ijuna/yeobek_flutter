// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/GetArtistHistory.dart
import '../artist_repo.dart';

final class GetArtistHistory {
  final ArtistRepo _repo;

  const GetArtistHistory(this._repo);

  /// GET /artist/history - 아티스트 변경 이력 조회
  /// artistId 또는 instaId 중 하나를 제공해야 함.
  Future<List<Map<String, dynamic>>> call({String? artistId, String? instaId}) => _repo.getArtistHistory(
    artistId: artistId,
    instaId: instaId,
  );
}
