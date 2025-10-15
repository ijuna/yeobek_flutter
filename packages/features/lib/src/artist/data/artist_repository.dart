import '../../artist/domain/artist_entity.dart';

abstract interface class ArtistRepository {
  Future<List<ArtistEntity>> fetch();
}
