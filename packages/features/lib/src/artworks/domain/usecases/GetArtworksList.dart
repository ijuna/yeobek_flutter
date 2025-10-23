import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/GetArtworksListResponseDto.dart';

class GetArtworksList {
  final ArtworksApi _api;

  GetArtworksList(this._api);

  Future<GetArtworksListResponseDto> call({
    int? page,
    int? size,
    int? artistId,
  }) async {
    return await _api.getArtworksList(
      page: page,
      size: size,
      artistId: artistId,
    );
  }
}
