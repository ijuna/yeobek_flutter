// tattoo_frontend/packages/features/lib/src/artist/domain/artist_entity.dart
//
// 역할: "앱 도메인 모델(순수/불변)"
// - UI/도메인에서 바로 쓰는 깨끗한 형태.
// - 서버/저장소 세부와 분리.
// - 가능하면 불변(final + const 생성자)로 유지하면 안전.

final class ArtistEntity {
  final int id;
  final String name;
  final String avatarUrl;

  /// 불변 객체로 다루기 위해 final + const 생성자를 사용.
  const ArtistEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}