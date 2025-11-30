// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/GetArtistExists.dart
import '../artist_repo.dart';

final class GetArtistExists {
  final ArtistRepo _repo;

  const GetArtistExists(this._repo);

  /// GET /artist/exists - 아티스트 존재 여부 확인
  /// artistId 또는 instaId 중 하나를 제공해야 함.
  /// 테스트 호환성을 위해 boolean만 반환.
  Future<bool> call({String? artistId, String? instaId}) async {
    final r = await _repo.getArtistExists(artistId: artistId, instaId: instaId);
    return r.exists;
  }
}
