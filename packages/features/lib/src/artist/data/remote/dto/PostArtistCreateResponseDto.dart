import 'package:json_annotation/json_annotation.dart';

part 'PostArtistCreateResponseDto.g.dart';

@JsonSerializable()
class PostArtistCreateResponseDto {
  final int id;

  PostArtistCreateResponseDto({
    required this.id,
  });

  factory PostArtistCreateResponseDto.fromJson(Map<String, dynamic> json) => _$PostArtistCreateResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostArtistCreateResponseDtoToJson(this);
}
