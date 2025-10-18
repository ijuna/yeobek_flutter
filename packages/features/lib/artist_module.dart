// tattoo_frontend/packages/features/lib/artist_module.dart
//
// 역할: "조립/배선 모듈"
// - 실행(I/O)은 하지 않음.
// - ArtistApi(Dio) → ArtistRepoImpl(api) → UseCase(GetArtistById) 를 한 번에 조립해서
//   UI가 간단히 꺼내 쓰도록 해주는 팩토리(편의층).
//
// 주의: 이 파일은 features 패키지의 "공개 API"에 가까움.
//       외부(UI)는 보통 이 모듈을 통해 유즈케이스를 받아 쓴다.

import 'package:dio/dio.dart';
import 'package:network/network.dart'; // 전역 Dio 싱글톤(Network.dio) 제공

import 'src/artist/domain/artist_repo.dart';
import 'src/artist/domain/usecases/get_artist_by_id.dart';
import 'src/artist/data/artist_repo_impl.dart';
import 'src/artist/data/remote/artist_api.dart';

final class ArtistModule {
  /// UI가 알 필요 없는 내부 의존성(Repo)
  final ArtistRepo repo;

  /// UI가 실제로 사용할 도메인 유즈케이스
  final GetArtistById getArtistById;

  const ArtistModule({
    required this.repo,
    required this.getArtistById,
  });

  /// 이미 만든 Repo를 외부에서 주입하고 싶을 때 쓰는 팩토리.
  /// (예: 테스트에서 FakeRepo를 주입)
  factory ArtistModule.fromRepo(ArtistRepo repo) {
    return ArtistModule(
      repo: repo,
      getArtistById: GetArtistById(repo),
    );
  }

  /// Retrofit API를 외부에서 주입하고 싶을 때(테스트/특수 baseUrl) 사용하는 팩토리.
  factory ArtistModule.fromApi(ArtistApi api) {
    final repo = ArtistRepoImpl(api); // 실행 주체는 RepoImpl
    return ArtistModule.fromRepo(repo);
  }

  /// Dio를 외부에서 주입할 때(완전 순수 조립).
  factory ArtistModule.fromDio(Dio dio, {String? baseUrl}) {
    final api = ArtistApi(dio, baseUrl: baseUrl);
    return ArtistModule.fromApi(api);
  }

  /// 앱이 따로 주입 안 해도 되는 "기본 조립"
  /// - Network.dio를 사용해 ArtistApi를 생성
  /// - 그 API로 RepoImpl/UseCase까지 한 번에 조립
  factory ArtistModule.defaultClient() {
    return ArtistModule.fromDio(Network.dio);
  }
}