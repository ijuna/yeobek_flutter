import 'package:json_annotation/json_annotation.dart';

part 'PostArtworksCreateRequestDto.g.dart';

@JsonSerializable()
class PostArtworksCreateRequestDto {
  final int artistId;
  final String? title;
  final String? description;
  final List<dynamic>? tags;
  final List<String>? genres;
  final List<String>? subjects;
  final List<String>? parts;
  final bool? beautyOn;
  final List<String>? beautyParts;
  // images는 multipart로 별도 처리

  const PostArtworksCreateRequestDto({
    required this.artistId,
    this.title,
    this.description,
    this.tags,
    this.genres,
    this.subjects,
    this.parts,
    this.beautyOn,
    this.beautyParts,
  });

  factory PostArtworksCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PostArtworksCreateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostArtworksCreateRequestDtoToJson(this);
}
