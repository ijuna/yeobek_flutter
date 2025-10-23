import 'package:json_annotation/json_annotation.dart';

part 'GetArtworksResponseDto.g.dart';

@JsonSerializable()
class GetArtworksResponseDto {
  final int artworkId;
  final int artistId;
  final String? title;
  final String? description;
  final List<dynamic>? tags;
  final List<String>? genres;
  final List<String>? subjects;
  final List<String>? parts;
  final bool? beautyOn;
  final List<String>? beautyParts;
  final List<String> imageUrls;
  final int likesCount;
  final String createdAt;
  final String? updatedAt;

  const GetArtworksResponseDto({
    required this.artworkId,
    required this.artistId,
    this.title,
    this.description,
    this.tags,
    this.genres,
    this.subjects,
    this.parts,
    this.beautyOn,
    this.beautyParts,
    required this.imageUrls,
    required this.likesCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory GetArtworksResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetArtworksResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetArtworksResponseDtoToJson(this);
}
