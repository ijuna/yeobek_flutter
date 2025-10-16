// tattoo_frontend/packages/network/lib/network.dart
import 'package:dio/dio.dart';

class Network {
  Network._();

  static Dio? _dio;

  /// 최초 접근 시 lazy-init. baseUrl은 dart-define으로 주입 가능.
  static Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://dummyjson.com',
        ),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return _dio!;
  }

  /// (선택) 런타임 재구성
  static void configure({
    String? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    final d = dio; // ensure init
    if (baseUrl != null) d.options.baseUrl = baseUrl;
    if (interceptors != null) {
      d.interceptors.clear();
      d.interceptors.addAll(interceptors);
    }
  }
}