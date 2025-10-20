// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/postArtistCreate.dart
import '../artist_repo.dart';

final class PostArtistCreate {
  final ArtistRepo _repo;

  /// Repo는 인터페이스 타입. (구현체엔 의존하지 않음)
  const PostArtistCreate(this._repo);

  /// 입력: name, instaId, followers, tags
  /// 출력: Future<int> (생성된 아티스트 id)
  /// 설명: "아티스트를 생성한다"는 행위를 추상화.
  Future<int> call({
    required String name,
    required String instaId,
    required int followers,
    required List<String> tags,
  }) => _repo.postArtistCreate(
    name: name,
    instaId: instaId,
    followers: followers,
    tags: tags,
  );
}
