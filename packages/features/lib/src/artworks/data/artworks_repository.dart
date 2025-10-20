import '../../artworks/domain/artworks_entity.dart';

abstract interface class ArtworksRepository {
  Future<List<ArtworksEntity>> fetch();
}
