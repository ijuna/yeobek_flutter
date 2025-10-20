// tattoo_frontend/packages/features/lib/src/artist/domain/artist_entity.dart
final class ArtistEntity {
  final int id;
  final String name;
  final String instaId;
  final int followers;
  final List<String> tags;
  final int level;
  final bool owner;
  final int rowVersion;

  /// 불변 객체로 다루기 위해 final + const 생성자를 사용.
  const ArtistEntity({
    required this.id,
    required this.name,
    required this.instaId,
    required this.followers,
    required this.tags,
    required this.level,
    required this.owner,
    required this.rowVersion,
  });
}
