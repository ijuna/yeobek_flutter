import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/DeleteArtworksResponseDto.dart';

class DeleteArtworks {
  final ArtworksApi _api;

  DeleteArtworks(this._api);

  Future<DeleteArtworksResponseDto> call(int artworkId) async {
    return await _api.deleteArtworks(artworkId);
  }
}
