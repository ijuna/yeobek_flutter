import 'package:json_annotation/json_annotation.dart';

part 'PutArtistResponseDto.g.dart';

@JsonSerializable()
class PutArtistResponseDto {
  PutArtistResponseDto();

  factory PutArtistResponseDto.fromJson(Map<String, dynamic> json) => _$PutArtistResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PutArtistResponseDtoToJson(this);
}
