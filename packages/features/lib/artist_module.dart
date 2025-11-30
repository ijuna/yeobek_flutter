// tattoo_frontend/packages/features/lib/artist_module.dart
//
// 역할: "조립/배선 모듈"
// - 실행(I/O)은 하지 않음.
// - ArtistApi(Dio) → ArtistRepoImpl(api) → UseCase 조립 예시
//   UI가 간단히 꺼내 쓰도록 해주는 팩토리(편의층).
//
// 주의: 이 파일은 features 패키지의 "공개 API"에 가까움.
//       외부(UI)는 보통 이 모듈을 통해 유즈케이스를 받아 쓴다.

import 'package:dio/dio.dart';
import 'package:network/network.dart';

import 'src/artist/domain/artist_repo.dart';
import 'src/artist/domain/usecases/GetArtistPing.dart';
import 'src/artist/domain/usecases/PostArtistCreate.dart';
import 'src/artist/domain/usecases/GetArtist.dart';
import 'src/artist/domain/usecases/PutArtist.dart';
import 'src/artist/domain/usecases/DeleteArtist.dart';
import 'src/artist/domain/usecases/GetArtistList.dart';
import 'src/artist/domain/usecases/GetArtistExists.dart';
import 'src/artist/domain/usecases/PostArtistRestore.dart';
import 'src/artist/domain/usecases/GetArtistHistory.dart';
import 'src/artist/data/artist_repo_impl.dart';
import 'src/artist/data/remote/artist_rest_api.dart';

// 테스트/외부 사용을 위해 API와 DTO도 export
export 'src/artist/data/remote/artist_rest_api.dart';
export 'src/artist/data/remote/dto/GetArtistPingResponseDto.dart';
export 'src/artist/data/remote/dto/PostArtistCreateRequestDto.dart';
export 'src/artist/data/remote/dto/PostArtistCreateResponseDto.dart';
export 'src/artist/data/remote/dto/GetArtistResponseDto.dart';
export 'src/artist/data/remote/dto/PutArtistRequestDto.dart';
export 'src/artist/data/remote/dto/PutArtistResponseDto.dart';
export 'src/artist/data/remote/dto/DeleteArtistRequestDto.dart';
export 'src/artist/data/remote/dto/DeleteArtistResponseDto.dart';
export 'src/artist/data/remote/dto/GetArtistListResponseDto.dart';
export 'src/artist/data/remote/dto/GetArtistExistsResponseDto.dart';
export 'src/artist/data/remote/dto/PostArtistRestoreResponseDto.dart';
export 'src/artist/data/remote/dto/GetArtistHistoryResponseDto.dart';

final class ArtistModule {
  final ArtistRepo repo;

  // Usecases
  final GetArtistPing getArtistPing;
  final PostArtistCreate postArtistCreate;
  final GetArtist getArtist;
  final PutArtist putArtist;
  final DeleteArtist deleteArtist;
  final GetArtistList getArtistList;
  final GetArtistExists getArtistExists;
  final PostArtistRestore postArtistRestore;
  final GetArtistHistory getArtistHistory;

  const ArtistModule({
    required this.repo,
    required this.getArtistPing,
    required this.postArtistCreate,
    required this.getArtist,
    required this.putArtist,
    required this.deleteArtist,
    required this.getArtistList,
    required this.getArtistExists,
    required this.postArtistRestore,
    required this.getArtistHistory,
  });

  factory ArtistModule.fromRepo(ArtistRepo repo) {
    return ArtistModule(
      repo: repo,
      getArtistPing: GetArtistPing(repo),
      postArtistCreate: PostArtistCreate(repo),
      getArtist: GetArtist(repo),
      putArtist: PutArtist(repo),
      deleteArtist: DeleteArtist(repo),
      getArtistList: GetArtistList(repo),
      getArtistExists: GetArtistExists(repo),
      postArtistRestore: PostArtistRestore(repo),
      getArtistHistory: GetArtistHistory(repo),
    );
  }

  factory ArtistModule.fromApi(ArtistRestApi api) {
    final repo = ArtistRepoImpl(api);
    return ArtistModule.fromRepo(repo);
  }

  factory ArtistModule.fromDio(Dio dio, {String? baseUrl}) {
    final api = ArtistRestApi(dio);
    return ArtistModule.fromApi(api);
  }

  factory ArtistModule.defaultClient() {
    return ArtistModule.fromDio(Network.dio);
  }
}
