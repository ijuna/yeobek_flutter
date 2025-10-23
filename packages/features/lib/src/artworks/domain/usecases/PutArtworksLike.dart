import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/PutArtworksLikeResponseDto.dart';

class PutArtworksLike {
  final ArtworksApi _api;

  PutArtworksLike(this._api);

  Future<PutArtworksLikeResponseDto> call(int artworkId) async {
    return await _api.putArtworksLike(artworkId);
  }
}
