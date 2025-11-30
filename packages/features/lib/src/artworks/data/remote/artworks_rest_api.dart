import 'package:dio/dio.dart';
import 'package:network/network.dart';

class ArtworksRestApi {
  final Dio _dio;
  ArtworksRestApi([Dio? dio]) : _dio = dio ?? Network.dio;

  Future<Response<dynamic>> postArtworks({
    required String title,
    String? description,
    String? tagsJson,
    String? genresJson,
    String? subjectsJson,
    String? partsJson,
    bool? beautyOn,
    String? beautyPartsJson,
    List<MultipartFile>? images,
    String? accessToken,
  }) async {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    final data = FormData();
    data.fields
      ..add(MapEntry('title', title))
      ..addAll([
        if (description != null) MapEntry('description', description),
        if (tagsJson != null) MapEntry('tags', tagsJson),
        if (genresJson != null) MapEntry('genres', genresJson),
        if (subjectsJson != null) MapEntry('subjects', subjectsJson),
        if (partsJson != null) MapEntry('parts', partsJson),
        if (beautyOn != null) MapEntry('beautyOn', beautyOn.toString()),
        if (beautyPartsJson != null) MapEntry('beautyParts', beautyPartsJson),
      ]);
    if (images != null) {
      for (final f in images) {
        data.files.add(MapEntry('images', f));
      }
    }
    return _dio.post('/artworks', data: data, options: Options(headers: headers));
  }

  Future<Response<dynamic>> getArtworksId({required String artworkId}) {
    return _dio.get('/artworks/$artworkId');
  }

  Future<Response<dynamic>> getArtworks({
    int? page,
    int? size,
    String? sort,
    String? userId,
    List<String>? tags,
    String? q,
  }) {
    final query = <String, dynamic>{
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sort != null) 'sort': sort,
      if (userId != null) 'userId': userId,
      if (tags != null) 'tags': tags,
      if (q != null) 'q': q,
    };
    return _dio.get(
      '/artworks',
      queryParameters: query,
      options: Options(validateStatus: (_) => true),
    );
  }

  Future<Response<dynamic>> patchArtworksId({
    required String artworkId,
    Map<String, dynamic>? body,
    String? accessToken,
  }) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    return _dio.patch('/artworks/$artworkId', data: body ?? const {}, options: Options(headers: headers));
  }

  Future<Response<dynamic>> putArtworksIdLike({required String artworkId, String? userId}) {
    final query = <String, dynamic>{ if (userId != null) 'userId': userId };
    return _dio.put(
      '/artworks/$artworkId/like',
      queryParameters: query,
      // Use default validateStatus so 4xx (e.g., duplicate like) throws when server returns 409/400
      options: Options(),
    );
  }

  Future<Response<dynamic>> deleteArtworksIdLike({required String artworkId, required String userId}) {
    return _dio.delete('/artworks/$artworkId/like', queryParameters: {'userId': userId});
  }

  Future<Response<dynamic>> deleteArtworksId({required String artworkId, String? accessToken}) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    return _dio.delete('/artworks/$artworkId', options: Options(headers: headers));
  }
}
