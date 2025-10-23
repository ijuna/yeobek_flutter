// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtworksResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtworksResponseDto _$GetArtworksResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtworksResponseDto(
      artworkId: (json['artworkId'] as num).toInt(),
      artistId: (json['artistId'] as num).toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as List<dynamic>?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parts:
          (json['parts'] as List<dynamic>?)?.map((e) => e as String).toList(),
      beautyOn: json['beautyOn'] as bool?,
      beautyParts: (json['beautyParts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      likesCount: (json['likesCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$GetArtworksResponseDtoToJson(
        GetArtworksResponseDto instance) =>
    <String, dynamic>{
      'artworkId': instance.artworkId,
      'artistId': instance.artistId,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'genres': instance.genres,
      'subjects': instance.subjects,
      'parts': instance.parts,
      'beautyOn': instance.beautyOn,
      'beautyParts': instance.beautyParts,
      'imageUrls': instance.imageUrls,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
