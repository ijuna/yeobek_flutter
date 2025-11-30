// Repository implementation for Artist domain

import 'dart:convert';
import 'package:dio/dio.dart';

import '../domain/artist_entity.dart';
import '../domain/artist_repo.dart';
import 'remote/artist_rest_api.dart';

final class ArtistRepoImpl implements ArtistRepo {
  final ArtistRestApi _api;

  const ArtistRepoImpl(this._api);

  @override
  Future<String> getArtistPing() async {
    final r = await _api.getPing();
    final m = _asMap(r.data);
    return (m['artist'] ?? m['ping'] ?? 'ok').toString();
  }

  @override
  Future<String> postArtistCreate({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
    String? accessToken,
  }) async {
    final r = await _api.postCreate(
      name: name,
      instaId: instaId,
      followers: followers,
      tags: tags,
      accessToken: accessToken,
    );
    final m = _asMap(r.data);
    return (m['artistId'] ?? m['id'] ?? '').toString();
  }

  @override
  Future<ArtistEntity> getArtist({String? instaId, String? name}) async {
    final r = await _api.getArtist(instaId: instaId, name: name);
    final m = _asMap(r.data);
    return ArtistEntity(
      artistId: (m['artistId'] ?? m['id'] ?? '').toString(),
      id: _asInt(m['id']) ?? 0,
      name: (m['name'] ?? '').toString(),
      instaId: (m['instaId'] ?? '').toString(),
      followers: _asInt(m['followers']) ?? 0,
      tags: (m['tags'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[],
      level: _asInt(m['level']) ?? 0,
      owner: (m['owner'] as bool?) ?? false,
      rowVersion: _asInt(m['rowVersion']) ?? 1,
    );
  }

  @override
  Future<ArtistEntity> putArtist({
    required String instaId,
    String? name,
    int? followers,
    List<String>? tags,
    required int rowVersion,
    String? accessToken,
  }) async {
    final resp = await _api.putArtist(
      instaId: instaId,
      name: name,
      followers: followers,
      tags: tags,
      rowVersion: rowVersion,
      accessToken: accessToken,
    );
    final m = _asMap(resp.data);
    return ArtistEntity(
      artistId: (m['artistId'] ?? m['id'] ?? '').toString(),
      id: _asInt(m['id']) ?? 0,
      name: (m['name'] ?? name ?? '').toString(),
      instaId: (m['instaId'] ?? instaId).toString(),
      followers: _asInt(m['followers']) ?? followers ?? 0,
      tags: (m['tags'] as List?)?.map((e) => e.toString()).toList() ?? (tags ?? const <String>[]),
      level: _asInt(m['level']) ?? 0,
      owner: (m['owner'] as bool?) ?? false,
      rowVersion: _asInt(m['rowVersion']) ?? rowVersion,
    );
  }

  @override
  Future<void> deleteArtist({required String instaId, String? comment, String? accessToken}) async {
    await _api.deleteArtist(instaId: instaId, comment: comment, accessToken: accessToken);
  }

  @override
  Future<List<ArtistEntity>> getArtistList({
    required String order,
    String? tags,
    String? match,
    String? q,
    int? pageSize,
    int? cursor,
  }) async {
    final r = await _api.getList(order: order, tags: tags, match: match, q: q, pageSize: pageSize, cursor: cursor);
    final m = _asMap(r.data);
    final items = (m['items'] as List?) ?? const [];
    return items.map((e) {
      final mm = _asMap(e);
      return ArtistEntity(
        artistId: (mm['artistId'] ?? mm['id'] ?? '').toString(),
        id: _asInt(mm['id']) ?? 0,
        name: (mm['name'] ?? '').toString(),
        instaId: (mm['instaId'] ?? '').toString(),
        followers: _asInt(mm['followers']) ?? 0,
        tags: (mm['tags'] as List?)?.map((v) => v.toString()).toList() ?? const <String>[],
        level: _asInt(mm['level']) ?? 0,
        owner: (mm['owner'] as bool?) ?? false,
        rowVersion: _asInt(mm['rowVersion']) ?? 1,
      );
    }).toList();
  }

  @override
  Future<({bool exists, String? artistId})> getArtistExists({String? artistId, String? instaId}) async {
    Response r;
    if (artistId != null) {
      r = await _api.getExistsByArtistId(artistId);
    } else if (instaId != null) {
      r = await _api.getExistsByInstaId(instaId);
    } else {
      return (exists: false, artistId: null);
    }
    final m = _asMap(r.data);
    return (exists: (m['exists'] as bool?) ?? false, artistId: (m['artistId'] ?? m['id'])?.toString());
  }

  @override
  Future<ArtistEntity> postArtistRestore({required String instaId, int? revisionId, int? rowVersion, String? accessToken}) async {
    final resp = await _api.postRestore(instaId: instaId, revisionId: revisionId, rowVersion: rowVersion, accessToken: accessToken);
    final root = _asMap(resp.data);
    // Some backends may nest payload under 'artist' or 'item'
    final nested = root['artist'] is Map
        ? Map<String, dynamic>.from(root['artist'] as Map)
        : root['item'] is Map
            ? Map<String, dynamic>.from(root['item'] as Map)
            : root['data'] is Map
                ? Map<String, dynamic>.from(root['data'] as Map)
                : <String, dynamic>{};
    final m = nested.isNotEmpty ? {...root, ...nested} : root;
    var entity = ArtistEntity(
      artistId: (m['artistId'] ?? m['id'] ?? '').toString(),
      id: _asInt(m['id']) ?? 0,
      name: (m['name'] ?? m['artistName'] ?? '').toString(),
      instaId: (m['instaId'] ?? '').toString(),
      followers: _asInt(m['followers']) ?? 0,
      tags: (m['tags'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[],
      level: _asInt(m['level']) ?? 0,
      owner: (m['owner'] as bool?) ?? false,
      rowVersion: _asInt(m['rowVersion']) ?? 1,
    );
    // Fallback: if name is empty, fetch latest artist by instaId
    if (entity.name.isEmpty) {
      try {
        entity = await getArtist(instaId: instaId);
      } catch (_) {}
    }
    return entity;
  }

  @override
  Future<List<Map<String, dynamic>>> getArtistHistory({String? artistId, String? instaId}) async {
    Response r;
    if (artistId != null) {
      r = await _api.getHistoryByArtistId(artistId);
    } else if (instaId != null) {
      r = await _api.getHistoryByInstaId(instaId);
    } else {
      return const [];
    }
    final m = _asMap(r.data);
    final list = (m['items'] as List?) ?? const [];
    return list.map((e) => _asMap(e)).toList();
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data as Map);
    if (data is String && data.isNotEmpty) {
      try { return json.decode(data) as Map<String, dynamic>; } catch (_) {}
    }
    return <String, dynamic>{};
  }

  int? _asInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
