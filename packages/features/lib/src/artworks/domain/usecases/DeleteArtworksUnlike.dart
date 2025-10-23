import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/DeleteArtworksUnlikeResponseDto.dart';

class DeleteArtworksUnlike {
  final ArtworksApi _api;

  DeleteArtworksUnlike(this._api);

  Future<DeleteArtworksUnlikeResponseDto> call(int artworkId) async {
    return await _api.deleteArtworksUnlike(artworkId);
  }
}
