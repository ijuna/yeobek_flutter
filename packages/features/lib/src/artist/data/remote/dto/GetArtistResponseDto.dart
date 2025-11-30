import 'package:json_annotation/json_annotation.dart';
import '../../../domain/artist_entity.dart';

part 'GetArtistResponseDto.g.dart';

@JsonSerializable()
class GetArtistResponseDto {
  final int id;
  final String name;
  final String instaId;
  final int followers;
  final List<String> tags;
  final int level;
  final bool owner;
  final int rowVersion;

  GetArtistResponseDto({
    required this.id,
    required this.name,
    required this.instaId,
    required this.followers,
    required this.tags,
    required this.level,
    required this.owner,
    required this.rowVersion,
  });

  factory GetArtistResponseDto.fromJson(Map<String, dynamic> json) => _$GetArtistResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistResponseDtoToJson(this);

  ArtistEntity toDomain() => ArtistEntity(
    artistId: '',
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
