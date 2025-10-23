// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeleteArtworksUnlikeResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteArtworksUnlikeResponseDto _$DeleteArtworksUnlikeResponseDtoFromJson(
        Map<String, dynamic> json) =>
    DeleteArtworksUnlikeResponseDto(
      message: json['message'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
    );

Map<String, dynamic> _$DeleteArtworksUnlikeResponseDtoToJson(
        DeleteArtworksUnlikeResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'likesCount': instance.likesCount,
    };
