import '../artworks_repo.dart';

final class PutArtworksIdLike {
  final ArtworksRepo _repo;
  const PutArtworksIdLike(this._repo);

  Future<void> call({required String artworkId, String? userId}) => _repo.putArtworksIdLike(artworkId: artworkId, userId: userId);
}
