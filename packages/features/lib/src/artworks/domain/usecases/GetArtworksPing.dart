import '../../data/remote/artworks_api.dart';
import '../../data/remote/dto/GetArtworksPingResponseDto.dart';

class GetArtworksPing {
  final ArtworksApi _api;

  GetArtworksPing(this._api);

  Future<GetArtworksPingResponseDto> call() async {
    return await _api.getArtworksPing();
  }
}
