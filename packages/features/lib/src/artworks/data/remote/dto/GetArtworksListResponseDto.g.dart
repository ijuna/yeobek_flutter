// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtworksListResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtworksListResponseDto _$GetArtworksListResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtworksListResponseDto(
      artworks: (json['artworks'] as List<dynamic>)
          .map((e) => ArtworkItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$GetArtworksListResponseDtoToJson(
        GetArtworksListResponseDto instance) =>
    <String, dynamic>{
      'artworks': instance.artworks,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

ArtworkItemDto _$ArtworkItemDtoFromJson(Map<String, dynamic> json) =>
    ArtworkItemDto(
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
    );

Map<String, dynamic> _$ArtworkItemDtoToJson(ArtworkItemDto instance) =>
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
    };
