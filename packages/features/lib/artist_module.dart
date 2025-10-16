// tattoo_frontend/packages/features/lib/artist_module.dart
import 'src/artist/domain/artist_repo.dart';
import 'src/artist/domain/usecases/get_artist_by_id.dart';
import 'src/artist/data/artist_repo_impl.dart';

final class ArtistModule {
  final ArtistRepo repo;
  final GetArtistById getArtistById;
  const ArtistModule({required this.repo, required this.getArtistById});

  /// 앱이 따로 주입 안 해도 되는 기본 조립
  factory ArtistModule.defaultClient() {
    final repo = ArtistRepoImpl(); // 내부에서 Network.dio 사용
    return ArtistModule(repo: repo, getArtistById: GetArtistById(repo));
  }
}