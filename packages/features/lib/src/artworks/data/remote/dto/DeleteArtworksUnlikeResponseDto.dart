import 'package:json_annotation/json_annotation.dart';

part 'DeleteArtworksUnlikeResponseDto.g.dart';

@JsonSerializable()
class DeleteArtworksUnlikeResponseDto {
  final String message;
  final int likesCount;

  const DeleteArtworksUnlikeResponseDto({
    required this.message,
    required this.likesCount,
  });

  factory DeleteArtworksUnlikeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteArtworksUnlikeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteArtworksUnlikeResponseDtoToJson(this);
}
