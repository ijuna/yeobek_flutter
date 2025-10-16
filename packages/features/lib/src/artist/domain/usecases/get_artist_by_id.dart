// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/get_artist_by_id.dart
import '../artist_entity.dart';
import '../artist_repo.dart';

final class GetArtistById {
  final ArtistRepo _repo;
  const GetArtistById(this._repo);
  Future<ArtistEntity> call(int id) => _repo.getById(id);
}