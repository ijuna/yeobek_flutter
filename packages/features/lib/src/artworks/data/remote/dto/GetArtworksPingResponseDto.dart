import 'package:json_annotation/json_annotation.dart';

part 'GetArtworksPingResponseDto.g.dart';

@JsonSerializable()
class GetArtworksPingResponseDto {
  final String message;

  const GetArtworksPingResponseDto({required this.message});

  factory GetArtworksPingResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetArtworksPingResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetArtworksPingResponseDtoToJson(this);
}
