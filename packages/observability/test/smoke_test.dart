import 'package:test/test.dart';
import 'package:observability/observability.dart';

void main() {
  test('Logger is creatable', () {
    final logger = createLogger('demo');
    expect(logger.name, 'demo');
  });
}
