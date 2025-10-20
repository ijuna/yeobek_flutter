import 'package:json_annotation/json_annotation.dart';

part 'PutArtistRequestDto.g.dart';

@JsonSerializable()
class PutArtistRequestDto {
  final String name;
  final int followers;
  final List<String> tags;
  final int rowVersion;

  PutArtistRequestDto({
    required this.name,
    required this.followers,
    required this.tags,
    required this.rowVersion,
  });

  factory PutArtistRequestDto.fromJson(Map<String, dynamic> json) => _$PutArtistRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PutArtistRequestDtoToJson(this);
}
