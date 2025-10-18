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
import 'remote/dto/artist_dto_remote.dart';

final class ArtistRepoImpl implements ArtistRepo {
  final ArtistApi _api;

  /// ArtistApi는 외부(모듈/DI)에서 만들어 주입한다.
  const ArtistRepoImpl(this._api);

  @override
  Future<ArtistEntity> getById(int id) async {
    // 1) 원격 호출 (Retrofit)
    final dto = await _api.getById(id);

    // 2) DTO → 도메인 엔티티로 변환(서버 형식을 앱 친화 모델로 정제)
    return dto.toDomain();
  }
}