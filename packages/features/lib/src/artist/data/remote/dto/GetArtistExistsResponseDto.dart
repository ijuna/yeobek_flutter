import 'package:json_annotation/json_annotation.dart';

part 'GetArtistExistsResponseDto.g.dart';

@JsonSerializable()
class GetArtistExistsResponseDto {
  final bool exists;
  final int? id;

  GetArtistExistsResponseDto({
    required this.exists,
    this.id,
  });

  factory GetArtistExistsResponseDto.fromJson(Map<String, dynamic> json) => _$GetArtistExistsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistExistsResponseDtoToJson(this);
}
