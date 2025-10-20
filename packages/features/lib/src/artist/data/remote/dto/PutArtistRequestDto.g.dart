// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PutArtistRequestDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutArtistRequestDto _$PutArtistRequestDtoFromJson(Map<String, dynamic> json) =>
    PutArtistRequestDto(
      name: json['name'] as String,
      followers: (json['followers'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      rowVersion: (json['rowVersion'] as num).toInt(),
    );

Map<String, dynamic> _$PutArtistRequestDtoToJson(
        PutArtistRequestDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'followers': instance.followers,
      'tags': instance.tags,
      'rowVersion': instance.rowVersion,
    };
