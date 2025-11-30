import '../artworks_repo.dart';

final class DeleteArtworksId {
  final ArtworksRepo _repo;
  const DeleteArtworksId(this._repo);

  Future<void> call({required String artworkId, String? accessToken}) => _repo.deleteArtworksId(artworkId: artworkId, accessToken: accessToken);
}
