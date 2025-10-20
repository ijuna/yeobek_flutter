// tattoo_frontend/packages/features/lib/src/artist/data/remote/artist_api.dart
//
// 역할: "Retrofit API 인터페이스"
// - 엔드포인트(메서드/경로/파라미터/헤더)를 선언하면
//   build_runner가 실제 호출 코드를 생성(artist_api.g.dart).
//
// 사용 예:
//   final api = ArtistApi(Network.dio);           // 모듈에서 조립
//   final dto = await api.getById(1);             // 호출
//
// 코드 생성 명령:
//   (repo 루트) $ dart run build_runner build -d
//
// 주의:
// - part 파일명(artist_api.g.dart)이 소스 파일명과 일치해야 한다.
// - baseUrl은 기본적으로 Network.dio.options.baseUrl 사용.
//   필요하면 생성 시 baseUrl 파라미터로 오버라이드 가능.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dto/GetArtistResponseDto.dart';
import 'dto/PostArtistCreateRequestDto.dart';
import 'dto/PostArtistCreateResponseDto.dart';
import 'dto/GetArtistPingResponseDto.dart';
import 'dto/PutArtistRequestDto.dart';
import 'dto/PutArtistResponseDto.dart';
import 'dto/DeleteArtistRequestDto.dart';
import 'dto/DeleteArtistResponseDto.dart';
import 'dto/GetArtistListResponseDto.dart';
import 'dto/GetArtistExistsResponseDto.dart';
import 'dto/PostArtistRestoreResponseDto.dart';
import 'dto/GetArtistHistoryResponseDto.dart';

part 'artist_api.g.dart';

@RestApi()
abstract class ArtistApi {
  /// Retrofit이 생성해주는 구현체(_ArtistApi)를 사용.
  factory ArtistApi(Dio dio, {String? baseUrl}) = _ArtistApi;

  /// GET /artist/ping
  @GET('/artist/ping')
  Future<GetArtistPingResponseDto> getArtistPing();

  /// POST /artist/create
  @POST('/artist/create')
  Future<PostArtistCreateResponseDto> postArtistCreate(@Body() PostArtistCreateRequestDto body);

  /// GET /artist?instaId=... | ?name=...
  @GET('/artist')
  Future<GetArtistResponseDto> getArtist({
    @Query('instaId') String? instaId,
    @Query('name') String? name,
  });

  /// PUT /artist
  @PUT('/artist')
  Future<PutArtistResponseDto> putArtist(
    @Query('instaId') String instaId,
    @Query('force') bool force,
    @Body() PutArtistRequestDto body,
  );

  /// DELETE /artist
  @DELETE('/artist')
  Future<DeleteArtistResponseDto> deleteArtist(
    @Query('instaId') String instaId,
    @Body() DeleteArtistRequestDto body,
  );

  /// GET /artist/list
  @GET('/artist/list')
  Future<GetArtistListResponseDto> getArtistList({
    @Query('order') required String order,
    @Query('tags') String? tags,
    @Query('match') String? match,
    @Query('q') String? q,
    @Query('page_size') int? pageSize,
    @Query('cursor') int? cursor,
  });

  /// GET /artist/exists
  @GET('/artist/exists')
  Future<GetArtistExistsResponseDto> getArtistExists(@Query('instaId') String instaId);

  /// POST /artist/restore
  @POST('/artist/restore')
  Future<PostArtistRestoreResponseDto> postArtistRestore(
    @Query('instaId') String instaId,
    @Query('rowVersion') int? rowVersion,
  );

  /// GET /artist/history
  @GET('/artist/history')
  Future<GetArtistHistoryResponseDto> getArtistHistory(@Query('instaId') String instaId);
}
