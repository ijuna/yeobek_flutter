import 'package:json_annotation/json_annotation.dart';

part 'PutArtworksLikeResponseDto.g.dart';

@JsonSerializable()
class PutArtworksLikeResponseDto {
  final String message;
  final int likesCount;

  const PutArtworksLikeResponseDto({
    required this.message,
    required this.likesCount,
  });

  factory PutArtworksLikeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PutArtworksLikeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PutArtworksLikeResponseDtoToJson(this);
}
