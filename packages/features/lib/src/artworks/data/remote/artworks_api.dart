import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dto/GetArtworksPingResponseDto.dart';
import 'dto/PostArtworksCreateResponseDto.dart';
import 'dto/GetArtworksListResponseDto.dart';
import 'dto/GetArtworksResponseDto.dart';
import 'dto/PatchArtworksResponseDto.dart';
import 'dto/DeleteArtworksResponseDto.dart';
import 'dto/PutArtworksLikeResponseDto.dart';
import 'dto/DeleteArtworksUnlikeResponseDto.dart';

part 'artworks_api.g.dart';

@RestApi()
abstract class ArtworksApi {
  factory ArtworksApi(Dio dio, {String baseUrl}) = _ArtworksApi;

  @GET('/artworks/ping')
  Future<GetArtworksPingResponseDto> getArtworksPing();

  @POST('/artworks/create')
  @MultiPart()
  Future<PostArtworksCreateResponseDto> postArtworksCreate({
    @Part(name: 'artistId') required int artistId,
    @Part(name: 'title') String? title,
    @Part(name: 'description') String? description,
    @Part(name: 'tags') String? tags,
    @Part(name: 'genres') String? genres,
    @Part(name: 'subjects') String? subjects,
    @Part(name: 'parts') String? parts,
    @Part(name: 'beautyOn') bool? beautyOn,
    @Part(name: 'beautyParts') String? beautyParts,
    @Part(name: 'images') List<MultipartFile>? images,
  });

  @GET('/artworks/list')
  Future<GetArtworksListResponseDto> getArtworksList({
    @Query('page') int? page,
    @Query('size') int? size,
    @Query('artistId') int? artistId,
  });

  @GET('/artworks/{artworkId}')
  Future<GetArtworksResponseDto> getArtworks(@Path('artworkId') int artworkId);

  @PATCH('/artworks/{artworkId}')
  @MultiPart()
  Future<PatchArtworksResponseDto> patchArtworks(
    @Path('artworkId') int artworkId, {
    @Part(name: 'title') String? title,
    @Part(name: 'description') String? description,
    @Part(name: 'tags') String? tags,
    @Part(name: 'genres') String? genres,
    @Part(name: 'subjects') String? subjects,
    @Part(name: 'parts') String? parts,
    @Part(name: 'beautyOn') bool? beautyOn,
    @Part(name: 'beautyParts') String? beautyParts,
    @Part(name: 'images') List<MultipartFile>? images,
  });

  @DELETE('/artworks/{artworkId}')
  Future<DeleteArtworksResponseDto> deleteArtworks(
    @Path('artworkId') int artworkId,
  );

  @PUT('/artworks/{artworkId}/like')
  Future<PutArtworksLikeResponseDto> putArtworksLike(
    @Path('artworkId') int artworkId,
  );

  @DELETE('/artworks/{artworkId}/unlike')
  Future<DeleteArtworksUnlikeResponseDto> deleteArtworksUnlike(
    @Path('artworkId') int artworkId,
  );
}
