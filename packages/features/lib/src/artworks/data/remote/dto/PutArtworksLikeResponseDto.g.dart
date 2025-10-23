// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PutArtworksLikeResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutArtworksLikeResponseDto _$PutArtworksLikeResponseDtoFromJson(
        Map<String, dynamic> json) =>
    PutArtworksLikeResponseDto(
      message: json['message'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
    );

Map<String, dynamic> _$PutArtworksLikeResponseDtoToJson(
        PutArtworksLikeResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'likesCount': instance.likesCount,
    };
