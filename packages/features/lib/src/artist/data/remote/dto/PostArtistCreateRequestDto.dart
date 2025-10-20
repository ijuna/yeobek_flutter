import 'package:json_annotation/json_annotation.dart';

part 'PostArtistCreateRequestDto.g.dart';

@JsonSerializable()
class PostArtistCreateRequestDto {
  final String name;
  final String instaId;
  final int followers;
  final List<String> tags;

  PostArtistCreateRequestDto({
    required this.name,
    required this.instaId,
    required this.followers,
    required this.tags,
  });

  factory PostArtistCreateRequestDto.fromJson(Map<String, dynamic> json) => _$PostArtistCreateRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostArtistCreateRequestDtoToJson(this);
}
