import 'dart:convert';
import 'package:dio/dio.dart';
import '../artworks_repo.dart';

final class PostArtworks {
  final ArtworksRepo _repo;
  const PostArtworks(this._repo);

  Future<String> call({
    required String title,
    String? description,
    // Structured params (preferred)
    List<Map<String, dynamic>>? tags,
    List<String>? genres,
    List<String>? subjects,
    List<String>? parts,
  Object? beautyOn,
    List<String>? beautyParts,
    // File uploads
    List<MultipartFile>? images,
    String? accessToken,
    // Compatibility params for backend-ported tests
    String? tagsJson,
    String? genresJson,
    String? subjectsJson,
    String? partsJson,
    String? beautyPartsJson,
  }) {
    // If JSON strings are provided, decode them into structured params
    final decodedTags = tags ?? _decodeListOfMap(tagsJson);
    final decodedGenres = genres ?? _decodeListOfString(genresJson);
    final decodedSubjects = subjects ?? _decodeListOfString(subjectsJson);
    final decodedParts = parts ?? _decodeListOfString(partsJson);
  final decodedBeautyParts = beautyParts ?? _decodeListOfString(beautyPartsJson);
  final resolvedBeautyOn = _decodeBool(beautyOn) ?? (beautyOn is bool ? beautyOn : null);

    return _repo.postArtworks(
      title: title,
      description: description,
      tags: decodedTags,
      genres: decodedGenres,
      subjects: decodedSubjects,
      parts: decodedParts,
      beautyOn: resolvedBeautyOn,
      beautyParts: decodedBeautyParts,
      images: images,
      accessToken: accessToken,
    );
  }

  List<Map<String, dynamic>>? _decodeListOfMap(String? jsonStr) {
    if (jsonStr == null) return null;
    try {
      final v = json.decode(jsonStr);
      if (v is List) {
        return v.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return e;
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{'value': e};
        }).toList();
      }
    } catch (_) {}
    return null;
  }

  List<String>? _decodeListOfString(String? jsonStr) {
    if (jsonStr == null) return null;
    try {
      final v = json.decode(jsonStr);
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return null;
  }

  bool? _decodeBool(Object? v) {
    if (v == null) return null;
    if (v is bool) return v;
    final s = v.toString().toLowerCase();
    if (s == 'true') return true;
    if (s == 'false') return false;
    return null;
  }
}
