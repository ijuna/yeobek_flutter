// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/GetArtist.dart
import '../artist_entity.dart';
import '../artist_repo.dart';

final class GetArtist {
  final ArtistRepo _repo;

  /// Repo는 인터페이스 타입. (구현체엔 의존하지 않음)
  const GetArtist(this._repo);

  /// 입력: instaId 또는 name
  /// 출력: Future<ArtistEntity>
  /// 설명: "아티스트 상세를 가져온다"는 행위를 추상화.
  Future<ArtistEntity> call({String? instaId, String? name}) => _repo.getArtist(instaId: instaId, name: name);
}
