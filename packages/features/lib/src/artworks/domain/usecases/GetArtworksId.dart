import '../artworks_entity.dart';
import '../artworks_repo.dart';

final class GetArtworksId {
  final ArtworksRepo _repo;
  const GetArtworksId(this._repo);

  Future<ArtworkEntity> call({required String artworkId}) => _repo.getArtworksId(artworkId: artworkId);
}
