// tattoo_frontend/packages/features/lib/src/artist/domain/artist_repo.dart
//
// 역할: "Repo 인터페이스(계약)"
// - 유즈케이스가 의존하는 추상 포트.
// - 구현체(Remote/Local/Cached)는 언제든 바뀔 수 있다.
// - HTTP/Dio/Retrofit 같은 세부는 여기서 알지 못한다.

import 'artist_entity.dart';

abstract interface class ArtistRepo {
  /// 입력: id(int)
  /// 출력: Future<ArtistEntity>
  /// 책임: 데이터 획득 전략을 숨기고, 도메인 엔티티를 제공한다.
  Future<ArtistEntity> getById(int id);
}