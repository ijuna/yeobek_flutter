// tattoo_frontend/packages/features/lib/src/artist/domain/usecases/DeleteArtist.dart
import '../artist_repo.dart';

final class DeleteArtist {
  final ArtistRepo _repo;

  const DeleteArtist(this._repo);

  /// DELETE /artist - 아티스트 삭제
  Future<void> call({required String instaId, String? comment, String? accessToken}) => _repo.deleteArtist(
    instaId: instaId,
    comment: comment,
    accessToken: accessToken,
  );
}
