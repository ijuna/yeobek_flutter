// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PatchArtworksRequestDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchArtworksRequestDto _$PatchArtworksRequestDtoFromJson(
        Map<String, dynamic> json) =>
    PatchArtworksRequestDto(
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
    );

Map<String, dynamic> _$PatchArtworksRequestDtoToJson(
        PatchArtworksRequestDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'genres': instance.genres,
      'subjects': instance.subjects,
      'parts': instance.parts,
      'beautyOn': instance.beautyOn,
      'beautyParts': instance.beautyParts,
    };
