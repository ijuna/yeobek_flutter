// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtistExistsResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtistExistsResponseDto _$GetArtistExistsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistExistsResponseDto(
      exists: json['exists'] as bool,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetArtistExistsResponseDtoToJson(
        GetArtistExistsResponseDto instance) =>
    <String, dynamic>{
      'exists': instance.exists,
      'id': instance.id,
    };
