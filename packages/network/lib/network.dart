// tattoo_frontend/packages/network/lib/network.dart
//
// 공개 퍼사드: 외부(앱/피처)는 이 파일만 임포트하면 됨.

//  - Network.dio : 전역 Dio 싱글톤
//  - setupNetwork : 인터셉터/로깅/재시도/토큰 주입 설정

import 'package:dio/dio.dart';

// 내부 구현(인터셉터/토큰/재시도)은 src로 감춤.
// 여기서 필요한 심볼만 사용.
import 'src/retrofit_config.dart' show TokenProvider, buildRetrofitInterceptors;

class Network {
  Network._();

  static Dio? _dio;

  /// 전역 Dio 싱글톤 (lazy-init).
  /// 기본 baseUrl은 --dart-define=API_BASE_URL (없으면 서버 루트).
  static Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://43.201.80.55',
        ),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return _dio!;
  }

  /// 런타임 재구성: baseUrl/인터셉터 세트 교체
  static void configure({String? baseUrl, List<Interceptor>? interceptors}) {
    final d = dio; // ensure init
    if (baseUrl != null) d.options.baseUrl = baseUrl;
    if (interceptors != null) {
      d.interceptors
        ..clear()
        ..addAll(interceptors);
    }
  }
}

/// 앱 시작 시 한 줄 설정(선택).
/// - [baseUrl]        : 기본 URL 교체 (보통 dart-define로 충분)
/// - [tokenProvider]  : Authorization Bearer 자동 주입 콜백
/// - [enableLogging]  : 개발 중 요청/응답 바디 로깅
/// - [retryCount]     : 타임아웃/5xx 등 재시도 횟수(0이면 비활성)
void setupNetwork({
  String? baseUrl,
  TokenProvider? tokenProvider,
  bool enableLogging = false,
  int retryCount = 0,
}) {
  final interceptors = buildRetrofitInterceptors(
    tokenProvider: tokenProvider,
    enableLogging: enableLogging,
    retryCount: retryCount,
    dioForRetry: Network.dio, // 재시도 시 사용할 동일 Dio
  );

  Network.configure(baseUrl: baseUrl, interceptors: interceptors);
}
