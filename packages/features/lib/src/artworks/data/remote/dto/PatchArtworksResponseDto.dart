import 'package:json_annotation/json_annotation.dart';

part 'PatchArtworksResponseDto.g.dart';

@JsonSerializable()
class PatchArtworksResponseDto {
  final String message;

  const PatchArtworksResponseDto({required this.message});

  factory PatchArtworksResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PatchArtworksResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PatchArtworksResponseDtoToJson(this);
}
