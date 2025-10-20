// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtistListResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtistListResponseDto _$GetArtistListResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistListResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => GetArtistListItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: (json['nextCursor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetArtistListResponseDtoToJson(
        GetArtistListResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
    };

GetArtistListItemDto _$GetArtistListItemDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistListItemDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      instaId: json['instaId'] as String,
      followers: (json['followers'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      level: (json['level'] as num).toInt(),
      owner: json['owner'] as bool,
      rowVersion: (json['rowVersion'] as num).toInt(),
    );

Map<String, dynamic> _$GetArtistListItemDtoToJson(
        GetArtistListItemDto instance) =>
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
