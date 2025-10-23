import 'package:dio/dio.dart';
import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/PatchArtworksResponseDto.dart';

class PatchArtworks {
  final ArtworksApi _api;

  PatchArtworks(this._api);

  Future<PatchArtworksResponseDto> call(
    int artworkId, {
    String? title,
    String? description,
    String? tags,
    String? genres,
    String? subjects,
    String? parts,
    bool? beautyOn,
    String? beautyParts,
    List<MultipartFile>? images,
  }) async {
    return await _api.patchArtworks(
      artworkId,
      title: title,
      description: description,
      tags: tags,
      genres: genres,
      subjects: subjects,
      parts: parts,
      beautyOn: beautyOn,
      beautyParts: beautyParts,
      images: images,
    );
  }
}
