import 'package:json_annotation/json_annotation.dart';

part 'DeleteArtistResponseDto.g.dart';

@JsonSerializable()
class DeleteArtistResponseDto {
  DeleteArtistResponseDto();

  factory DeleteArtistResponseDto.fromJson(Map<String, dynamic> json) => _$DeleteArtistResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteArtistResponseDtoToJson(this);
}
