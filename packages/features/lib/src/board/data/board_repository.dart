import '../../board/domain/board_entity.dart';

abstract interface class BoardRepository {
  Future<List<BoardEntity>> fetch();
}
