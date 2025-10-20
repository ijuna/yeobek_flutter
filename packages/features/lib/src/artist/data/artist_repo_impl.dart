// tattoo_frontend/packages/features/lib/src/artist/data/artist_repo_impl.dart
//
// 역할: "데이터 접근의 실행자(Repository 구현)"
// - 실제로 Retrofit API를 호출(I/O)하고
// - 서버 JSON(=DTO)을 도메인 엔티티로 변환(toDomain)한 뒤 반환.
// - 캐시/로컬을 붙이고 싶다면 이 클래스에서 전략을 추가.
//
// 중요한 점:
// - 여기서는 Network.dio를 직접 잡지 않음(조립 책임은 모듈/DI에게).
// - 반드시 ArtistApi를 "생성자 주입" 받는다.

import '../domain/artist_entity.dart';
import '../domain/artist_repo.dart';
import 'remote/artist_api.dart';
import 'remote/dto/PostArtistCreateRequestDto.dart';
import 'remote/dto/PutArtistRequestDto.dart';
import 'remote/dto/DeleteArtistRequestDto.dart';

final class ArtistRepoImpl implements ArtistRepo {
  final ArtistApi _api;

  /// ArtistApi는 외부(모듈/DI)에서 만들어 주입한다.
  const ArtistRepoImpl(this._api);

  @override
  Future<String> getArtistPing() async {
    final dto = await _api.getArtistPing();
    return dto.artist;
  }

  @override
  Future<int> postArtistCreate({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
  }) async {
    final request = PostArtistCreateRequestDto(
      name: name,
      instaId: instaId,
      followers: followers,
      tags: tags,
    );
    final response = await _api.postArtistCreate(request);
    return response.id;
  }

  @override
  Future<ArtistEntity> getArtist({String? instaId, String? name}) async {
    final dto = await _api.getArtist(instaId: instaId, name: name);
    return dto.toDomain();
  }

  @override
  Future<void> putArtist({
    required String instaId,
    required bool force,
    required String name,
    required int followers,
    required List<String> tags,
    required int rowVersion,
  }) async {
    final request = PutArtistRequestDto(
      name: name,
      followers: followers,
      tags: tags,
      rowVersion: rowVersion,
    );
    await _api.putArtist(instaId, force, request);
  }

  @override
  Future<void> deleteArtist({required String instaId, required String reason}) async {
    final request = DeleteArtistRequestDto(reason: reason);
    await _api.deleteArtist(instaId, request);
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
    final dto = await _api.getArtistList(
      order: order,
      tags: tags,
      match: match,
      q: q,
      pageSize: pageSize,
      cursor: cursor,
    );
    return dto.items.map((item) => item.toDomain()).toList();
  }

  @override
  Future<({bool exists, int? id})> getArtistExists({required String instaId}) async {
    final dto = await _api.getArtistExists(instaId);
    return (exists: dto.exists, id: dto.id);
  }

  @override
  Future<void> postArtistRestore({required String instaId, int? rowVersion}) async {
    await _api.postArtistRestore(instaId, rowVersion);
  }

  @override
  Future<List<dynamic>> getArtistHistory({required String instaId}) async {
    final dto = await _api.getArtistHistory(instaId);
    return dto.items;
  }
}
