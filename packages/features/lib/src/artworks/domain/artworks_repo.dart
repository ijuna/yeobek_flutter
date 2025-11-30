import 'artworks_entity.dart';
import 'package:dio/dio.dart';

abstract interface class ArtworksRepo {
  // POST /artworks
  Future<String> postArtworks({
    required String title,
    String? description,
    List<Map<String, dynamic>>? tags,
    List<String>? genres,
    List<String>? subjects,
    List<String>? parts,
    bool? beautyOn,
    List<String>? beautyParts,
    List<MultipartFile>? images,
    String? accessToken,
  });

  // GET /artworks/{id}
  Future<ArtworkEntity> getArtworksId({required String artworkId});

  // GET /artworks
  Future<({List<ArtworkEntity> items, int total})> getArtworks({
    int? page,
    int? size,
    String? sort, // popular | views | default
    String? userId,
    List<String>? tags,
    String? q,
  });

  // PATCH /artworks/{id}
  Future<void> patchArtworksId({
    required String artworkId,
    String? title,
    String? description,
    List<Map<String, dynamic>>? tags,
    String? accessToken,
  });

  // PUT /artworks/{id}/like
  Future<void> putArtworksIdLike({required String artworkId, String? userId});

  // DELETE /artworks/{id}/like
  Future<void> deleteArtworksIdLike({required String artworkId, required String userId});

  // DELETE /artworks/{id}
  Future<void> deleteArtworksId({required String artworkId, String? accessToken});
}
