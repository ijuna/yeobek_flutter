// apps/app_web/lib/main.dart (예시 - 참고)
import 'package:flutter/material.dart';
import 'package:features/features.dart';   // 배럴이 있다면 모듈/유즈케이스를 export
import 'package:network/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // (선택) 전역 네트워크 정책 장착
  setupNetwork(
    // baseUrl: 'https://dummyjson.com', // 기본값이면 생략
    enableLogging: true,
    retryCount: 2,
    tokenProvider: () async => null,
  );

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final artist = ArtistModule.defaultClient(); // 조립 완료된 모듈

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Artist Demo')),
        body: FutureBuilder(
          future: artist.getArtistById(1),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final a = snap.data!;
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(a.avatarUrl)),
              title: Text(a.name),
              subtitle: Text('id=${a.id}'),
            );
          },
        ),
      ),
    );
  }
}