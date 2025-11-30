import 'package:dio/dio.dart';
import 'package:network/network.dart';

import 'src/artworks/domain/artworks_repo.dart';
import 'src/artworks/domain/usecases/PostArtworks.dart';
import 'src/artworks/domain/usecases/GetArtworks.dart';
import 'src/artworks/domain/usecases/GetArtworksId.dart';
import 'src/artworks/domain/usecases/PatchArtworksId.dart';
import 'src/artworks/domain/usecases/PutArtworksIdLike.dart';
import 'src/artworks/domain/usecases/DeleteArtworksIdLike.dart';
import 'src/artworks/domain/usecases/DeleteArtworksId.dart';
import 'src/artworks/data/artworks_repo_impl.dart';
import 'src/artworks/data/remote/artworks_rest_api.dart';

export 'src/artworks/data/remote/artworks_rest_api.dart';

final class ArtworksModule {
  final ArtworksRepo repo;
  final PostArtworks postArtworks;
  final GetArtworks getArtworks;
  final GetArtworksId getArtworksId;
  final PatchArtworksId patchArtworksId;
  final PutArtworksIdLike putArtworksIdLike;
  final DeleteArtworksIdLike deleteArtworksIdLike;
  final DeleteArtworksId deleteArtworksId;

  const ArtworksModule({
    required this.repo,
    required this.postArtworks,
    required this.getArtworks,
    required this.getArtworksId,
    required this.patchArtworksId,
    required this.putArtworksIdLike,
    required this.deleteArtworksIdLike,
    required this.deleteArtworksId,
  });

  factory ArtworksModule.fromRepo(ArtworksRepo repo) => ArtworksModule(
        repo: repo,
        postArtworks: PostArtworks(repo),
        getArtworks: GetArtworks(repo),
        getArtworksId: GetArtworksId(repo),
        patchArtworksId: PatchArtworksId(repo),
        putArtworksIdLike: PutArtworksIdLike(repo),
        deleteArtworksIdLike: DeleteArtworksIdLike(repo),
        deleteArtworksId: DeleteArtworksId(repo),
      );

  factory ArtworksModule.fromApi(ArtworksRestApi api) => ArtworksModule.fromRepo(ArtworksRepoImpl(api));

  factory ArtworksModule.fromDio(Dio dio) => ArtworksModule.fromApi(ArtworksRestApi(dio));

  factory ArtworksModule.defaultClient() => ArtworksModule.fromDio(Network.dio);
}
