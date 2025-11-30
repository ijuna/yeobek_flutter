import 'package:dio/dio.dart';
import 'package:network/network.dart';
import 'data/artworks_repo_impl.dart';
import 'data/remote/artworks_rest_api.dart';
import 'domain/artworks_repo.dart';
import 'domain/usecases/PostArtworks.dart';
import 'domain/usecases/GetArtworksId.dart';
import 'domain/usecases/GetArtworks.dart';
import 'domain/usecases/PatchArtworksId.dart';
import 'domain/usecases/PutArtworksIdLike.dart';
import 'domain/usecases/DeleteArtworksIdLike.dart';
import 'domain/usecases/DeleteArtworksId.dart';

/// Artworks Module for dependency injection
abstract class ArtworksModule {
  // ========== UseCase Factories ==========
  
  static PostArtworks postArtworks({ArtworksRepo? repo}) =>
      PostArtworks(repo ?? _defaultRepo());
  
  static GetArtworksId getArtworksId({ArtworksRepo? repo}) =>
      GetArtworksId(repo ?? _defaultRepo());
  
  static GetArtworks getArtworks({ArtworksRepo? repo}) =>
      GetArtworks(repo ?? _defaultRepo());
  
  static PatchArtworksId patchArtworksId({ArtworksRepo? repo}) =>
      PatchArtworksId(repo ?? _defaultRepo());
  
  static PutArtworksIdLike putArtworksIdLike({ArtworksRepo? repo}) =>
      PutArtworksIdLike(repo ?? _defaultRepo());
  
  static DeleteArtworksIdLike deleteArtworksIdLike({ArtworksRepo? repo}) =>
      DeleteArtworksIdLike(repo ?? _defaultRepo());
  
  static DeleteArtworksId deleteArtworksId({ArtworksRepo? repo}) =>
      DeleteArtworksId(repo ?? _defaultRepo());

  // ========== Repo Factories ==========
  
  static ArtworksRepo fromApi(ArtworksRestApi api) => ArtworksRepoImpl(api);
  
  static ArtworksRepo fromDio(Dio dio) => ArtworksRepoImpl(ArtworksRestApi(dio));
  
  static ArtworksRepo defaultClient() => _defaultRepo();

  // ========== Private ==========
  
  static ArtworksRepo _defaultRepo() => ArtworksRepoImpl(ArtworksRestApi(Network.dio));
}
