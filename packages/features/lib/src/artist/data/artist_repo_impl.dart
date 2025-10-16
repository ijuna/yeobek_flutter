// tattoo_frontend/packages/features/lib/src/artist/data/artist_repo_impl.dart
import '../domain/artist_entity.dart';
import '../domain/artist_repo.dart';
import 'remote/artist_api.dart';
import 'remote/dto/artist_dto_remote.dart';
import 'package:network/network.dart';

/// 최소 구현: 원격만 호출 (로컬 필요시 교체/확장)
final class ArtistRepoImpl implements ArtistRepo {
  late final ArtistApi _api;

  ArtistRepoImpl() {
    _api = ArtistApi(Network.dio, baseUrl: Network.dio.options.baseUrl);
  }

  @override
  Future<ArtistEntity> getById(int id) async {
    final dto = await _api.getById(id);
    return dto.toDomain();
  }
}