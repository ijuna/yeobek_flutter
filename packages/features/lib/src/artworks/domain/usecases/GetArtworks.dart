import '../artworks_entity.dart';
import '../artworks_repo.dart';

final class GetArtworks {
  final ArtworksRepo _repo;
  const GetArtworks(this._repo);

  Future<({List<ArtworkEntity> items, int total})> call({
    int? page,
    int? size,
    String? sort,
    String? userId,
    List<String>? tags,
    String? q,
  }) => _repo.getArtworks(page: page, size: size, sort: sort, userId: userId, tags: tags, q: q);
}
