import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/GetArtworksResponseDto.dart';

class GetArtworks {
  final ArtworksApi _api;

  GetArtworks(this._api);

  Future<GetArtworksResponseDto> call(int artworkId) async {
    return await _api.getArtworks(artworkId);
  }
}
