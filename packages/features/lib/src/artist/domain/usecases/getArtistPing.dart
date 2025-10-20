// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/getArtistPing.dart
import '../artist_repo.dart';

final class GetArtistPing {
  final ArtistRepo _repo;

  const GetArtistPing(this._repo);

  /// GET /artist/ping - 헬스 체크
  Future<String> call() => _repo.getArtistPing();
}
