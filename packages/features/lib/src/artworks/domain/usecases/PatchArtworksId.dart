import '../artworks_repo.dart';

final class PatchArtworksId {
  final ArtworksRepo _repo;
  const PatchArtworksId(this._repo);

  Future<void> call({
    required String artworkId,
    String? title,
    String? description,
    List<Map<String, dynamic>>? tags,
    String? accessToken,
  }) => _repo.patchArtworksId(
    artworkId: artworkId,
    title: title,
    description: description,
    tags: tags,
    accessToken: accessToken,
  );
}
