import 'package:json_annotation/json_annotation.dart';

part 'GetArtworksListResponseDto.g.dart';

@JsonSerializable()
class GetArtworksListResponseDto {
  final List<ArtworkItemDto> artworks;
  final int total;
  final int page;
  final int size;

  const GetArtworksListResponseDto({
    required this.artworks,
    required this.total,
    required this.page,
    required this.size,
  });

  factory GetArtworksListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetArtworksListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetArtworksListResponseDtoToJson(this);
}

@JsonSerializable()
class ArtworkItemDto {
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

  const ArtworkItemDto({
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
  });

  factory ArtworkItemDto.fromJson(Map<String, dynamic> json) =>
      _$ArtworkItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkItemDtoToJson(this);
}
