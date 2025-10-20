import 'package:json_annotation/json_annotation.dart';

part 'GetArtistPingResponseDto.g.dart';

@JsonSerializable()
class GetArtistPingResponseDto {
  final String artist;

  GetArtistPingResponseDto({
    required this.artist,
  });

  factory GetArtistPingResponseDto.fromJson(Map<String, dynamic> json) => _$GetArtistPingResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistPingResponseDtoToJson(this);
}
