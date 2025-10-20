// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetArtistHistoryResponseDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtistHistoryResponseDto _$GetArtistHistoryResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistHistoryResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              GetArtistHistoryItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetArtistHistoryResponseDtoToJson(
        GetArtistHistoryResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

GetArtistHistoryItemDto _$GetArtistHistoryItemDtoFromJson(
        Map<String, dynamic> json) =>
    GetArtistHistoryItemDto(
      revNo: (json['revNo'] as num).toInt(),
      ts: json['ts'] as String?,
      actorIp: json['actorIp'] as String?,
      action: json['action'] as String?,
      comment: json['comment'] as String?,
      deletedLike: json['deletedLike'] as bool,
      snapshot: json['snapshot'] as Map<String, dynamic>?,
      diff: json['diff'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GetArtistHistoryItemDtoToJson(
        GetArtistHistoryItemDto instance) =>
    <String, dynamic>{
      'revNo': instance.revNo,
      'ts': instance.ts,
      'actorIp': instance.actorIp,
      'action': instance.action,
      'comment': instance.comment,
      'deletedLike': instance.deletedLike,
      'snapshot': instance.snapshot,
      'diff': instance.diff,
    };
