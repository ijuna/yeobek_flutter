import 'dart:convert';
import 'package:dio/dio.dart';
import '../domain/artworks_entity.dart';
import '../domain/artworks_repo.dart';
import 'remote/artworks_rest_api.dart';

class ArtworksRepoImpl implements ArtworksRepo {
  final ArtworksRestApi _api;
  ArtworksRepoImpl(this._api);

  @override
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
  }) async {
    final res = await _api.postArtworks(
      title: title,
      description: description,
      tagsJson: tags == null ? null : _jsonEncode(tags),
      genresJson: genres == null ? null : _jsonEncode(genres),
      subjectsJson: subjects == null ? null : _jsonEncode(subjects),
      partsJson: parts == null ? null : _jsonEncode(parts),
      beautyOn: beautyOn,
      beautyPartsJson: beautyParts == null ? null : _jsonEncode(beautyParts),
      images: images,
      accessToken: accessToken,
    );
    final data = res.data as Map<String, dynamic>;
    return data['artworkId'] as String? ?? data['id'] as String? ?? '';
  }

  @override
  Future<ArtworkEntity> getArtworksId({required String artworkId}) async {
    final res = await _api.getArtworksId(artworkId: artworkId);
    final data = res.data as Map<String, dynamic>;
    return ArtworkEntity.fromJson(data);
  }

  @override
  Future<({List<ArtworkEntity> items, int total})> getArtworks({
    int? page,
    int? size,
    String? sort,
    String? userId,
    List<String>? tags,
    String? q,
  }) async {
    final res = await _api.getArtworks(page: page, size: size, sort: sort, userId: userId, tags: tags, q: q);
    final body = res.data as Map<String, dynamic>;
    final items = (body['items'] as List? ?? const [])
        .map((e) => ArtworkEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = (body['total'] is int) ? body['total'] as int : int.tryParse('${body['total']}') ?? items.length;
    return (items: items, total: total);
  }

  @override
  Future<void> patchArtworksId({
    required String artworkId,
    String? title,
    String? description,
    List<Map<String, dynamic>>? tags,
    String? accessToken,
  }) async {
    final body = <String, dynamic>{
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
    };
    await _api.patchArtworksId(artworkId: artworkId, body: body, accessToken: accessToken);
  }

  @override
  Future<void> putArtworksIdLike({required String artworkId, String? userId}) async {
    await _api.putArtworksIdLike(artworkId: artworkId, userId: userId);
  }

  @override
  Future<void> deleteArtworksIdLike({required String artworkId, required String userId}) async {
    await _api.deleteArtworksIdLike(artworkId: artworkId, userId: userId);
  }

  @override
  Future<void> deleteArtworksId({required String artworkId, String? accessToken}) async {
    await _api.deleteArtworksId(artworkId: artworkId, accessToken: accessToken);
  }
}

String _jsonEncode(Object o) => jsonEncode(o);
