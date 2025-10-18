// tattoo_frontend/packages/network/lib/src/retrofit_config.dart
//
// 내부 구현(비공개): 인터셉터/토큰 주입/단순 재시도.

import 'dart:async';
import 'package:dio/dio.dart';

/// 토큰을 동적으로 얻기 위한 콜백(동기/비동기 허용).
typedef TokenProvider = FutureOr<String?> Function();

/// 공용 인터셉터 세트 빌더.
/// - tokenProvider : 있으면 Authorization: Bearer <token> 자동 주입
/// - enableLogging : dev에서 요청/응답 바디 로깅
/// - retryCount    : 타임아웃/네트워크/5xx 재시도 횟수(0=off)
/// - dioForRetry   : 재시도에 사용할 Dio(동일 인스턴스 보장)
List<Interceptor> buildRetrofitInterceptors({
  TokenProvider? tokenProvider,
  bool enableLogging = false,
  int retryCount = 0,
  Dio? dioForRetry,
}) {
  final list = <Interceptor>[];

  if (tokenProvider != null) {
    list.add(_AuthTokenInterceptor(tokenProvider));
  }

  if (retryCount > 0) {
    list.add(_RetryInterceptor(
      retryCount: retryCount,
      dio: dioForRetry,
    ));
  }

  if (enableLogging) {
    list.add(LogInterceptor(
      requestHeader: false,
      responseHeader: false,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  return list;
}

/// 요청 시 Authorization 헤더 자동 주입.
/// 호출부에서 이미 Authorization을 명시했다면 덮어쓰지 않음.
class _AuthTokenInterceptor extends Interceptor {
  _AuthTokenInterceptor(this._provider);
  final TokenProvider _provider;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await _provider();
      if (token != null && token.isNotEmpty) {
        options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      }
    } catch (_) {
      // 토큰 조회 실패는 요청을 막지 않음
    }
    handler.next(options);
  }
}

/// 아주 단순한 지수 백오프 재시도.
/// - 타임아웃/연결 오류/5xx만 재시도
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor({
    required this.retryCount,
    Dio? dio,
  }) : _dio = dio;

  final int retryCount;
  final Dio? _dio; // 없으면 err.requestOptions을 통해 얻기 시도

  static const _retryKey = '__retry_count__';

  bool _isRetriable(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return true;
    }
    final status = e.response?.statusCode ?? 0;
    return status >= 500 && status < 600; // 5xx
  }

  Duration _backoff(int attempt) {
    // 200ms, 400ms, 800ms, ... (최대 2초)
    final ms = 200 * (1 << attempt);
    return Duration(milliseconds: ms > 2000 ? 2000 : ms);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final req = err.requestOptions;
    final current = (req.extra[_retryKey] as int?) ?? 0;

    if (current >= retryCount || !_isRetriable(err)) {
      handler.next(err);
      return;
    }

    // 백오프 후 동일 요청 재시도
    await Future<void>.delayed(_backoff(current));

    final dio = _dio ?? err.requestOptions as dynamic;
    final client = (dio is Dio) ? dio : null;

    if (client == null) {
      // Dio를 얻지 못하면 포기
      handler.next(err);
      return;
    }

    try {
      final result = await client.request<dynamic>(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: Options(
          method: req.method,
          headers: req.headers,
          responseType: req.responseType,
          contentType: req.contentType,
          followRedirects: req.followRedirects,
          listFormat: req.listFormat,
          receiveDataWhenStatusError: req.receiveDataWhenStatusError,
          extra: {...req.extra, _retryKey: current + 1},
          validateStatus: req.validateStatus,
          sendTimeout: req.sendTimeout,
          receiveTimeout: req.receiveTimeout,
        ),
        cancelToken: req.cancelToken,
        onSendProgress: req.onSendProgress,
        onReceiveProgress: req.onReceiveProgress,
      );
      handler.resolve(result);
    } catch (_) {
      handler.next(err);
    }
  }
}