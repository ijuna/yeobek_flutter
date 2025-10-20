// tattoo_frontend/packages/features/lib/src/artist/domain/artist_repo.dart
import 'artist_entity.dart';

abstract interface class ArtistRepo {
  /// GET /artist/ping
  Future<String> getArtistPing();
  
  /// POST /artist/create
  Future<int> postArtistCreate({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
  });
  
  /// GET /artist?instaId=... 또는 ?name=...
  Future<ArtistEntity> getArtist({String? instaId, String? name});
  
  /// PUT /artist
  Future<void> putArtist({
    required String instaId,
    required bool force,
    required String name,
    required int followers,
    required List<String> tags,
    required int rowVersion,
  });
  
  /// DELETE /artist
  Future<void> deleteArtist({required String instaId, required String reason});
  
  /// GET /artist/list
  Future<List<ArtistEntity>> getArtistList({
    required String order,
    String? tags,
    String? match,
    String? q,
    int? pageSize,
    int? cursor,
  });
  
  /// GET /artist/exists
  Future<({bool exists, int? id})> getArtistExists({required String instaId});
  
  /// POST /artist/restore
  Future<void> postArtistRestore({required String instaId, int? rowVersion});
  
  /// GET /artist/history
  Future<List<dynamic>> getArtistHistory({required String instaId});
}
