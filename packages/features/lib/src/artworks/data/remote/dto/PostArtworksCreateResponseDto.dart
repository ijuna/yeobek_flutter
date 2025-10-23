import 'package:json_annotation/json_annotation.dart';

part 'PostArtworksCreateResponseDto.g.dart';

@JsonSerializable()
class PostArtworksCreateResponseDto {
  final int artworkId;
  final String message;

  const PostArtworksCreateResponseDto({
    required this.artworkId,
    required this.message,
  });

  factory PostArtworksCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PostArtworksCreateResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostArtworksCreateResponseDtoToJson(this);
}
