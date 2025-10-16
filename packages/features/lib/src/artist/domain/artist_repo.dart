// tattoo_frontend/packages/features/lib/src/artist/domain/artist_repo.dart
import 'artist_entity.dart';

abstract interface class ArtistRepo {
  Future<ArtistEntity> getById(int id);
}