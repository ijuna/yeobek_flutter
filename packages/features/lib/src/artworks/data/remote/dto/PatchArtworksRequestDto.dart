import 'package:json_annotation/json_annotation.dart';

part 'PatchArtworksRequestDto.g.dart';

@JsonSerializable()
class PatchArtworksRequestDto {
  final String? title;
  final String? description;
  final List<dynamic>? tags;
  final List<String>? genres;
  final List<String>? subjects;
  final List<String>? parts;
  final bool? beautyOn;
  final List<String>? beautyParts;

  const PatchArtworksRequestDto({
    this.title,
    this.description,
    this.tags,
    this.genres,
    this.subjects,
    this.parts,
    this.beautyOn,
    this.beautyParts,
  });

  factory PatchArtworksRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PatchArtworksRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PatchArtworksRequestDtoToJson(this);
}
