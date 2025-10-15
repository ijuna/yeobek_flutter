import 'package:test/test.dart';
import 'package:network/network.dart';

void main() {
  test('DioClient is constructible', () {
    final c = DioClient(baseUrl: 'https://example.com');
    expect(c.dio.options.baseUrl, 'https://example.com');
  });
}
