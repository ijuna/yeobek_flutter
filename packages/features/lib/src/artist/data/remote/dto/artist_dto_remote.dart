// tattoo_frontend/packages/features/lib/src/artist/data/remote/dto/artist_dto_remote.dart
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

  factory ArtistDto.fromJson(Map<String, dynamic> json) => _$ArtistDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistDtoToJson(this);

  ArtistEntity toDomain() {
    final full = [firstName ?? '', lastName ?? '']
        .where((e) => e.trim().isNotEmpty)
        .join(' ')
        .trim();
    return ArtistEntity(
      id: id,
      name: full.isEmpty ? 'Artist $id' : full,
      avatarUrl: (image ?? '').isEmpty ? 'https://i.pravatar.cc/150?img=$id' : image!,
    );
  }
}