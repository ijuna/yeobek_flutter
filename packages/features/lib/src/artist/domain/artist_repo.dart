// tattoo_frontend/packages/features/lib/src/artist/domain/artist_repo.dart
import 'artist_entity.dart';

abstract interface class ArtistRepo {
  /// GET /artist/ping
  Future<String> getArtistPing();
  
  /// POST /artist/create
  Future<String> postArtistCreate({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
    String? accessToken,
  });
  
  /// GET /artist?instaId=... 또는 ?name=...
  Future<ArtistEntity> getArtist({String? instaId, String? name});
  
  /// PUT /artist
  Future<ArtistEntity> putArtist({
    required String instaId,
    String? name,
    int? followers,
    List<String>? tags,
    required int rowVersion,
    String? accessToken,
  });
  
  /// DELETE /artist
  Future<void> deleteArtist({required String instaId, String? comment, String? accessToken});
  
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
  Future<({bool exists, String? artistId})> getArtistExists({String? artistId, String? instaId});
  
  /// POST /artist/restore
  /// 백엔드 호환: revisionId 또는 rowVersion 둘 중 하나 사용
  Future<ArtistEntity> postArtistRestore({
    required String instaId,
    int? revisionId,
    int? rowVersion,
    String? accessToken,
  });
  
  /// GET /artist/history
  Future<List<Map<String, dynamic>>> getArtistHistory({String? artistId, String? instaId});
}
