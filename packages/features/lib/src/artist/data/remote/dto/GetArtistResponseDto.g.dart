// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtistResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtistResponseDto _$GetArtistResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      instaId: json['instaId'] as String,
      followers: (json['followers'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      level: (json['level'] as num).toInt(),
      owner: json['owner'] as bool,
      rowVersion: (json['rowVersion'] as num).toInt(),
    );

Map<String, dynamic> _$GetArtistResponseDtoToJson(
        GetArtistResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'instaId': instance.instaId,
      'followers': instance.followers,
      'tags': instance.tags,
      'level': instance.level,
      'owner': instance.owner,
      'rowVersion': instance.rowVersion,
    };
