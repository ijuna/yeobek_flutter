// apps/app_web/test/artist_api_test.dart
// 목적: features 패키지의 ArtistApi(Retrofit)를 사용해 실제 API 호출 테스트

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';
import 'package:features/features.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  group('ArtistApi 통합 테스트', () {
    late ArtistApi artistApi;

    setUp(() {
      artistApi = ArtistApi(Network.dio);
    });

    test('postArtistCreate → getArtist 흐름 테스트', () async {
      // 1) 아티스트 생성
      final ts = DateTime.now().millisecondsSinceEpoch;
      final request = PostArtistCreateRequestDto(
        name: 'test artist $ts',
        instaId: 'test_$ts',
        followers: 0,
        tags: ['string'],
      );

      final createResponse = await artistApi.postArtistCreate(request);
      expect(createResponse.id, isNotNull);

      // ignore: avoid_print
      print('Created artist ID: ${createResponse.id}');

      // 2) 생성한 아티스트 조회
      final artist = await artistApi.getArtist(instaId: 'test_$ts');

      expect(artist.id, equals(createResponse.id));
      expect(artist.name, equals('test artist $ts'));
      expect(artist.instaId, equals('test_$ts'));
      expect(artist.followers, equals(0));
      expect(artist.tags, contains('string'));

      // ignore: avoid_print
      print('Fetched artist: ${artist.toJson()}');
    });

    test('Artist 전체 엔드포인트 통합 시나리오', () async {
      final ts = DateTime.now().millisecondsSinceEpoch;
      final instaId = 'test_$ts';
      final name = 'test artist $ts';
      final tags = ['string'];

      // 1. Ping
      final ping = await artistApi.getArtistPing();
      expect(ping.artist, 'pong');
      print('Ping: ${ping.artist}');

      // 2. Create
      final createReq = PostArtistCreateRequestDto(
        name: name,
        instaId: instaId,
        followers: 0,
        tags: tags,
      );
      final createResp = await artistApi.postArtistCreate(createReq);
      expect(createResp.id, isNotNull);
      print('Created artist ID: ${createResp.id}');

      // 3. Get
      final artist = await artistApi.getArtist(instaId: instaId);
      expect(artist.id, equals(createResp.id));
      expect(artist.name, equals(name));
      expect(artist.instaId, equals(instaId));
      print('Fetched artist: ${artist.toJson()}');

      // 4. Put (Update)
      final putReq = PutArtistRequestDto(
        name: '$name updated',
        followers: 10,
        tags: ['updated'],
        rowVersion: artist.rowVersion,
      );
      final putResp = await artistApi.putArtist(instaId, false, putReq);
      print('Put response: ${putResp.toJson()}');

      // 5. Get List
      final listResp = await artistApi.getArtistList(order: 'created_desc');
      expect(listResp.items.any((item) => item.instaId == instaId), isTrue);
      print('List contains created artist: ${listResp.items.length}');

      // 6. Exists
      final existsResp = await artistApi.getArtistExists(instaId);
      expect(existsResp.exists, isTrue);
      expect(existsResp.id, equals(createResp.id));
      print('Exists: ${existsResp.exists}, id: ${existsResp.id}');

      // 7. History
      final historyResp = await artistApi.getArtistHistory(instaId);
      expect(historyResp.items, isNotEmpty);
      print('History count: ${historyResp.items.length}');

      // 8. Restore (실제 삭제 후 복원 테스트는 생략)
      final restoreResp = await artistApi.postArtistRestore(instaId, null);
      print('Restore response: ${restoreResp.toJson()}');

      // 9. Delete
      final deleteReq = DeleteArtistRequestDto(reason: 'test cleanup');
      final deleteResp = await artistApi.deleteArtist(instaId, deleteReq);
      print('Delete response: ${deleteResp.toJson()}');
    });
  });
}
