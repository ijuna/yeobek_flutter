import 'package:json_annotation/json_annotation.dart';

part 'GetArtistHistoryResponseDto.g.dart';

@JsonSerializable()
class GetArtistHistoryResponseDto {
  final List<GetArtistHistoryItemDto> items;

  GetArtistHistoryResponseDto({
    required this.items,
  });

  factory GetArtistHistoryResponseDto.fromJson(Map<String, dynamic> json) => _$GetArtistHistoryResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistHistoryResponseDtoToJson(this);
}

@JsonSerializable()
class GetArtistHistoryItemDto {
  final int revNo;
  final String? ts;
  final String? actorIp;
  final String? action;
  final String? comment;
  final bool deletedLike;
  final Map<String, dynamic>? snapshot;
  final Map<String, dynamic>? diff;

  GetArtistHistoryItemDto({
    required this.revNo,
    this.ts,
    this.actorIp,
    this.action,
    this.comment,
    required this.deletedLike,
    this.snapshot,
    this.diff,
  });

  factory GetArtistHistoryItemDto.fromJson(Map<String, dynamic> json) => _$GetArtistHistoryItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetArtistHistoryItemDtoToJson(this);
}
