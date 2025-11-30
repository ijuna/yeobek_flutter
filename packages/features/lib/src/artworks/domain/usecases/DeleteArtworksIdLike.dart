import '../artworks_repo.dart';

final class DeleteArtworksIdLike {
  final ArtworksRepo _repo;
  const DeleteArtworksIdLike(this._repo);

  Future<void> call({required String artworkId, required String userId}) => _repo.deleteArtworksIdLike(artworkId: artworkId, userId: userId);
}
