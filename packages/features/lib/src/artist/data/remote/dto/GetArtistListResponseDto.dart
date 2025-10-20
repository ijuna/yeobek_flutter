import 'package:json_annotation/json_annotation.dart';
import '../../../domain/artist_entity.dart';

part 'GetArtistListResponseDto.g.dart';

@JsonSerializable()
class GetArtistListResponseDto {
  final List<GetArtistListItemDto> items;
  final int? nextCursor;

  GetArtistListResponseDto({
    required this.items,
    this.nextCursor,
  });

  factory GetArtistListResponseDto.fromJson(Map<String, dynamic> json) => _$GetArtistListResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistListResponseDtoToJson(this);
}

@JsonSerializable()
class GetArtistListItemDto {
  final int id;
  final String name;
  final String instaId;
  final int followers;
  final List<String> tags;
  final int level;
  final bool owner;
  final int rowVersion;

  GetArtistListItemDto({
    required this.id,
    required this.name,
    required this.instaId,
    required this.followers,
    required this.tags,
    required this.level,
    required this.owner,
    required this.rowVersion,
  });

  factory GetArtistListItemDto.fromJson(Map<String, dynamic> json) => _$GetArtistListItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistListItemDtoToJson(this);

  ArtistEntity toDomain() => ArtistEntity(
    id: id,
    name: name,
    instaId: instaId,
    followers: followers,
    tags: tags,
    level: level,
    owner: owner,
    rowVersion: rowVersion,
  );
}
