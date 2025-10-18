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
import 'dto/artist_dto_remote.dart';

part 'artist_api.g.dart';

@RestApi()
abstract class ArtistApi {
  /// Retrofit이 생성해주는 구현체(_ArtistApi)를 사용.
  factory ArtistApi(Dio dio, {String? baseUrl}) = _ArtistApi;

  /// GET /users/{id} → JSON → ArtistDto
  @GET('/users/{id}')
  Future<ArtistDto> getById(@Path('id') int id);
}