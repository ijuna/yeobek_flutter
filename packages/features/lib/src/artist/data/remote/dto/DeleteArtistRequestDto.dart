import 'package:json_annotation/json_annotation.dart';

part 'DeleteArtistRequestDto.g.dart';

@JsonSerializable()
class DeleteArtistRequestDto {
  final String reason;

  DeleteArtistRequestDto({
    required this.reason,
  });

  factory DeleteArtistRequestDto.fromJson(Map<String, dynamic> json) => _$DeleteArtistRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteArtistRequestDtoToJson(this);
}
