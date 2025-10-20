import 'package:json_annotation/json_annotation.dart';

part 'PostArtistRestoreResponseDto.g.dart';

@JsonSerializable()
class PostArtistRestoreResponseDto {
  PostArtistRestoreResponseDto();

  factory PostArtistRestoreResponseDto.fromJson(Map<String, dynamic> json) => _$PostArtistRestoreResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostArtistRestoreResponseDtoToJson(this);
}
