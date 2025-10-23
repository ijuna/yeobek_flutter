import 'package:dio/dio.dart';
import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/PostArtworksCreateResponseDto.dart';

class PostArtworksCreate {
  final ArtworksApi _api;

  PostArtworksCreate(this._api);

  Future<PostArtworksCreateResponseDto> call({
    required int artistId,
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
    return await _api.postArtworksCreate(
      artistId: artistId,
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
