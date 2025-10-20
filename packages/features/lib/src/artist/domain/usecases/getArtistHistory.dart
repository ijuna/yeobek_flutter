// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/getArtistHistory.dart
import '../artist_repo.dart';

final class GetArtistHistory {
  final ArtistRepo _repo;

  const GetArtistHistory(this._repo);

  /// GET /artist/history - 아티스트 변경 이력 조회
  Future<List<dynamic>> call({required String instaId}) => _repo.getArtistHistory(
    instaId: instaId,
  );
}
