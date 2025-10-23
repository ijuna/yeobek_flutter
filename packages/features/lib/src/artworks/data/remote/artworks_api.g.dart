// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artworks_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ArtworksApi implements ArtworksApi {
  _ArtworksApi(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<GetArtworksPingResponseDto> getArtworksPing() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetArtworksPingResponseDto>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/ping',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetArtworksPingResponseDto _value;
    try {
      _value = GetArtworksPingResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PostArtworksCreateResponseDto> postArtworksCreate({
    required int artistId,
    String? title,
    String? description,
    String? tags,
    String? genres,
    String? subjects,
    String? parts,
    bool? beautyOn,
    String? beautyParts,
    List<MultipartFile>? images,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'artistId',
      artistId.toString(),
    ));
    if (title != null) {
      _data.fields.add(MapEntry(
        'title',
        title,
      ));
    }
    if (description != null) {
      _data.fields.add(MapEntry(
        'description',
        description,
      ));
    }
    if (tags != null) {
      _data.fields.add(MapEntry(
        'tags',
        tags,
      ));
    }
    if (genres != null) {
      _data.fields.add(MapEntry(
        'genres',
        genres,
      ));
    }
    if (subjects != null) {
      _data.fields.add(MapEntry(
        'subjects',
        subjects,
      ));
    }
    if (parts != null) {
      _data.fields.add(MapEntry(
        'parts',
        parts,
      ));
    }
    if (beautyOn != null) {
      _data.fields.add(MapEntry(
        'beautyOn',
        beautyOn.toString(),
      ));
    }
    if (beautyParts != null) {
      _data.fields.add(MapEntry(
        'beautyParts',
        beautyParts,
      ));
    }
    if (images != null) {
      _data.files.addAll(images.map((i) => MapEntry('images', i)));
    }
    final _options = _setStreamType<PostArtworksCreateResponseDto>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/artworks/create',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PostArtworksCreateResponseDto _value;
    try {
      _value = PostArtworksCreateResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetArtworksListResponseDto> getArtworksList({
    int? page,
    int? size,
    int? artistId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'size': size,
      r'artistId': artistId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetArtworksListResponseDto>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/list',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetArtworksListResponseDto _value;
    try {
      _value = GetArtworksListResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetArtworksResponseDto> getArtworks(int artworkId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetArtworksResponseDto>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/${artworkId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetArtworksResponseDto _value;
    try {
      _value = GetArtworksResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PatchArtworksResponseDto> patchArtworks(
    int artworkId, {
    String? title,
    String? description,
    String? tags,
    String? genres,
    String? subjects,
    String? parts,
    bool? beautyOn,
    String? beautyParts,
    List<MultipartFile>? images,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (title != null) {
      _data.fields.add(MapEntry(
        'title',
        title,
      ));
    }
    if (description != null) {
      _data.fields.add(MapEntry(
        'description',
        description,
      ));
    }
    if (tags != null) {
      _data.fields.add(MapEntry(
        'tags',
        tags,
      ));
    }
    if (genres != null) {
      _data.fields.add(MapEntry(
        'genres',
        genres,
      ));
    }
    if (subjects != null) {
      _data.fields.add(MapEntry(
        'subjects',
        subjects,
      ));
    }
    if (parts != null) {
      _data.fields.add(MapEntry(
        'parts',
        parts,
      ));
    }
    if (beautyOn != null) {
      _data.fields.add(MapEntry(
        'beautyOn',
        beautyOn.toString(),
      ));
    }
    if (beautyParts != null) {
      _data.fields.add(MapEntry(
        'beautyParts',
        beautyParts,
      ));
    }
    if (images != null) {
      _data.files.addAll(images.map((i) => MapEntry('images', i)));
    }
    final _options = _setStreamType<PatchArtworksResponseDto>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/artworks/${artworkId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PatchArtworksResponseDto _value;
    try {
      _value = PatchArtworksResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteArtworksResponseDto> deleteArtworks(int artworkId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DeleteArtworksResponseDto>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/${artworkId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteArtworksResponseDto _value;
    try {
      _value = DeleteArtworksResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PutArtworksLikeResponseDto> putArtworksLike(int artworkId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PutArtworksLikeResponseDto>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/${artworkId}/like',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PutArtworksLikeResponseDto _value;
    try {
      _value = PutArtworksLikeResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteArtworksUnlikeResponseDto> deleteArtworksUnlike(
      int artworkId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DeleteArtworksUnlikeResponseDto>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/artworks/${artworkId}/unlike',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteArtworksUnlikeResponseDto _value;
    try {
      _value = DeleteArtworksUnlikeResponseDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
