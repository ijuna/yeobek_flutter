// tattoo_frontend/packages/features/lib/src/artist/data/remote/dto/artist_dto_remote.dart
//
// 역할: "서버 JSON ↔ DTO" + "DTO → 도메인 엔티티 변환"
// - 서버 필드명(firstName/lastName/image)과 앱 도메인 모델의 필드명을 분리.
// - 누락/널/기본값 등을 여기에서 정리하면, 도메인/UI는 깔끔해짐.
//
// 코드 생성 명령:
//   (repo 루트) $ dart run build_runner build -d
//
// 주의:
// - part 파일명(artist_dto_remote.g.dart)이 소스 파일명과 일치해야 한다.
// - DTO는 서버 응답에 맞춰 nullable을 넉넉히 두고,
//   toDomain에서 앱에 필요한 형태로 "정제"하는 게 일반적.

import 'package:json_annotation/json_annotation.dart';
import '../../../domain/artist_entity.dart';

part 'artist_dto_remote.g.dart';

@JsonSerializable()
class ArtistDto {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? image;

  ArtistDto({required this.id, this.firstName, this.lastName, this.image});

  /// JSON → DTO (코드 생성)
  factory ArtistDto.fromJson(Map<String, dynamic> json) => _$ArtistDtoFromJson(json);

  /// DTO → JSON (코드 생성)
  Map<String, dynamic> toJson() => _$ArtistDtoToJson(this);

  /// DTO → 도메인 엔티티
  /// - 이름: firstName/lastName을 공백 기준으로 합침(둘 다 없으면 "Artist {id}")
  /// - 아바타: image가 없으면 pravatar 기본 이미지로 대체
  ArtistEntity toDomain() {
    final full = [firstName ?? '', lastName ?? '']
        .where((e) => e.trim().isNotEmpty)
        .join(' ')
        .trim();

    return ArtistEntity(
      id: id,
      name: full.isEmpty ? 'Artist $id' : full,
      avatarUrl: (image ?? '').isEmpty
          ? 'https://i.pravatar.cc/150?img=$id'
          : image!,
    );
  }
}