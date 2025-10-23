// apps/app_web/lib/main.dart (예시 - 참고)
import 'package:flutter/material.dart';
// 배럴이 있다면 모듈/유즈케이스를 export
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Artist Demo')),
        body: const Center(child: Text('아티스트 API 예시: getArtistById 제거됨')),
      ),
    );
  }
}
