// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/get_artist_by_id.dart
//
// 역할: "도메인 행위(무엇을 할 것인가)"를 표현.
// - 입력(id) → 출력(ArtistEntity) 형태로 "행동"만 정의.
// - Repo 인터페이스(계약)만 알고, 구현/HTTP 세부는 전혀 모름.
// - UI는 이 유즈케이스만 호출하면 됨.

import '../artist_entity.dart';
import '../artist_repo.dart';

final class GetArtistById {
  final ArtistRepo _repo;

  /// Repo는 인터페이스 타입. (구현체엔 의존하지 않음)
  const GetArtistById(this._repo);

  /// 입력: id(int)
  /// 출력: Future<ArtistEntity>
  /// 설명: "아티스트 상세를 가져온다"는 행위를 추상화.
  Future<ArtistEntity> call(int id) => _repo.getById(id);
}