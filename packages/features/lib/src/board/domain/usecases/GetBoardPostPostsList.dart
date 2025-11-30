import '../board_repo.dart';
import '../board_entity.dart';

final class GetBoardPostPostsList {
  final BoardRepo _repo;
  const GetBoardPostPostsList(this._repo);

  Future<({List<BoardEntity> posts, int? total})> call({String? boardId, int? page, int? size, String? sort, String? q})
    => _repo.getBoardPostPostsList(boardId: boardId, page: page, size: size, sort: sort, q: q);
}
