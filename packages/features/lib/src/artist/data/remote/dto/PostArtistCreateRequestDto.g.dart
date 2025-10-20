// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostArtistCreateRequestDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostArtistCreateRequestDto _$PostArtistCreateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    PostArtistCreateRequestDto(
      name: json['name'] as String,
      instaId: json['instaId'] as String,
      followers: (json['followers'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PostArtistCreateRequestDtoToJson(
        PostArtistCreateRequestDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'instaId': instance.instaId,
      'followers': instance.followers,
      'tags': instance.tags,
    };
