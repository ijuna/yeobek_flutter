// Artwork domain entity (aligned to backend test contracts)
class ArtworkEntity {
  final String artworkId;
  final String title;
  final String? description;
  final List<dynamic> images; // backend returns array; keep dynamic for flexibility
  final int? viewCount;
  final int? likesCount;
  final String? userId;

  // Extended fields per backend tests
  final List<Map<String, dynamic>>? tags; // [{id, name}, ...]
  final List<String>? genres;
  final List<String>? subjects;
  final List<String>? parts;
  final bool? beautyOn;
  final List<String>? beautyParts;
  final String? createdAt; // ISO8601 timestamp
  final String? updatedAt;

  const ArtworkEntity({
    required this.artworkId,
    required this.title,
    this.description,
    this.images = const [],
    this.viewCount,
    this.likesCount,
    this.userId,
    this.tags,
    this.genres,
    this.subjects,
    this.parts,
    this.beautyOn,
    this.beautyParts,
    this.createdAt,
    this.updatedAt,
  });

  factory ArtworkEntity.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    List<Map<String, dynamic>>? parseTagList(dynamic value) {
      if (value is List) {
        return value.map((e) {
          if (e is Map<String, dynamic>) return e;
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      }
      return null;
    }

    List<String>? parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    }

    return ArtworkEntity(
      artworkId: json['artworkId'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      images: (json['images'] as List?)?.toList() ?? const [],
      viewCount: parseIntSafe(json['viewCount']),
      likesCount: parseIntSafe(json['likesCount']),
      userId: json['userId']?.toString(),
      tags: parseTagList(json['tags']),
      genres: parseStringList(json['genres']),
      subjects: parseStringList(json['subjects']),
      parts: parseStringList(json['parts']),
      beautyOn: json['beautyOn'] as bool?,
      beautyParts: parseStringList(json['beautyParts']),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
