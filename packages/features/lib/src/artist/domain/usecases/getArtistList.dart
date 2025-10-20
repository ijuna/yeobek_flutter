// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/getArtistList.dart
import '../artist_entity.dart';
import '../artist_repo.dart';

final class GetArtistList {
  final ArtistRepo _repo;

  const GetArtistList(this._repo);

  /// GET /artist/list - 아티스트 목록 조회
  Future<List<ArtistEntity>> call({
    required String order,
    String? tags,
    String? match,
    String? q,
    int? pageSize,
    int? cursor,
  }) => _repo.getArtistList(
    order: order,
    tags: tags,
    match: match,
    q: q,
    pageSize: pageSize,
    cursor: cursor,
  );
}
