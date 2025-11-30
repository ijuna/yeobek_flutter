import 'package:dio/dio.dart';
import 'package:network/network.dart';

/// Artist REST API (수기 Dio 래퍼) - 백엔드 테스트 스크립트와 1:1 정렬
class ArtistRestApi {
  final Dio _dio;
  ArtistRestApi([Dio? dio]) : _dio = dio ?? Network.dio;

  Future<Response<dynamic>> getPing() => _dio.get('/artist/ping');

  Future<Response<dynamic>> postCreate({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
    String? accessToken,
  }) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    return _dio.post(
      '/artist/create',
      data: {
        'name': name,
        'instaId': instaId,
        'followers': followers,
        'tags': tags,
      },
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> getArtist({String? instaId, String? name}) {
    final query = <String, dynamic>{
      if (instaId != null) 'instaId': instaId,
      if (name != null) 'name': name,
    };
    return _dio.get('/artist', queryParameters: query);
  }

  Future<Response<dynamic>> putArtist({
    required String instaId,
    String? name,
    int? followers,
    List<String>? tags,
    required int rowVersion,
    String? accessToken,
  }) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    final data = <String, dynamic>{
      'rowVersion': rowVersion,
      if (name != null) 'name': name,
      if (followers != null) 'followers': followers,
      if (tags != null) 'tags': tags,
    };
    return _dio.put(
      '/artist',
      queryParameters: {'instaId': instaId},
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> deleteArtist({
    required String instaId,
    String? comment,
    String? accessToken,
  }) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    return _dio.delete(
      '/artist',
      queryParameters: {'instaId': instaId},
      data: comment == null ? null : {'comment': comment},
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> getExistsByArtistId(String artistId) {
    return _dio.get('/artist/exists', queryParameters: {'artistId': artistId});
  }

  Future<Response<dynamic>> getExistsByInstaId(String instaId) {
    return _dio.get('/artist/exists', queryParameters: {'instaId': instaId});
  }

  Future<Response<dynamic>> getHistoryByArtistId(String artistId) {
    return _dio.get('/artist/history', queryParameters: {'artistId': artistId});
  }

  Future<Response<dynamic>> getHistoryByInstaId(String instaId) {
    return _dio.get('/artist/history', queryParameters: {'instaId': instaId});
  }

  Future<Response<dynamic>> getList({
    required String order,
    String? tags,
    String? match,
    String? q,
    int? pageSize,
    int? cursor,
  }) {
    final query = <String, dynamic>{
      'order': order,
      if (tags != null) 'tags': tags,
      if (match != null) 'match': match,
      if (q != null) 'q': q,
      if (pageSize != null) 'page_size': pageSize,
      if (cursor != null) 'cursor': cursor,
    };
    return _dio.get('/artist/list', queryParameters: query);
  }

  Future<Response<dynamic>> postRestore({
    required String instaId,
    int? revisionId,
    int? rowVersion,
    String? accessToken,
  }) {
    final headers = <String, dynamic>{};
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';
    final query = <String, dynamic>{
      'instaId': instaId,
      if (revisionId != null) 'revisionId': revisionId,
      if (rowVersion != null) 'rowVersion': rowVersion,
    };
    return _dio.post('/artist/restore', queryParameters: query, options: Options(headers: headers));
  }
}
