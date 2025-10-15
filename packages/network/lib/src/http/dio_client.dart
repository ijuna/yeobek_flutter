import 'package:dio/dio.dart';

final class DioClient {
  DioClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
          ),
        );

  final Dio _dio;
  Dio get dio => _dio;
}
