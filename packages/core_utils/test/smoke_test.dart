import 'package:test/test.dart';
import 'package:core_utils/core_utils.dart';

void main() {
  test('StringBlank extension exists', () {
    String? s;
    expect(s.isBlank, isTrue);
    expect('x'.isBlank, isFalse);
  });
}
