// tattoo_frontend/packages/features/lib/src/artist/data/remote/artist_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dto/artist_dto_remote.dart';

part 'artist_api.g.dart';

/// baseUrl은 Network.dio.options.baseUrl 사용
@RestApi()
abstract class ArtistApi {
  factory ArtistApi(Dio dio, {String? baseUrl}) = _ArtistApi;

  @GET('/users/{id}')
  Future<ArtistDto> getById(@Path('id') int id);
}