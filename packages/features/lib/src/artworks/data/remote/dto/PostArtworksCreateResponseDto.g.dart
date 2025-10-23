// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostArtworksCreateResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostArtworksCreateResponseDto _$PostArtworksCreateResponseDtoFromJson(
        Map<String, dynamic> json) =>
    PostArtworksCreateResponseDto(
      artworkId: (json['artworkId'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$PostArtworksCreateResponseDtoToJson(
        PostArtworksCreateResponseDto instance) =>
    <String, dynamic>{
      'artworkId': instance.artworkId,
      'message': instance.message,
    };
