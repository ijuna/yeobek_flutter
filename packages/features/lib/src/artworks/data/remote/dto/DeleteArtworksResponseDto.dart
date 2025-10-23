import 'package:json_annotation/json_annotation.dart';

part 'DeleteArtworksResponseDto.g.dart';

@JsonSerializable()
class DeleteArtworksResponseDto {
  final String message;

  const DeleteArtworksResponseDto({required this.message});

  factory DeleteArtworksResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteArtworksResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteArtworksResponseDtoToJson(this);
}
