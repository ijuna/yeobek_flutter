import 'package:test/test.dart';
import 'package:core_domain/core_domain.dart';

void main() {
  test('UserId exists and holds value', () {
    const id = UserId('x');
    expect(id.value, 'x');
  });
}
