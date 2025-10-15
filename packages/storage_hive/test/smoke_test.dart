import 'package:test/test.dart';
import 'package:storage_hive/storage_hive.dart';

void main() {
  test('StorageImpl is constructible', () {
    final s = StorageImpl();
    expect(s, isA<StorageImpl>());
  });
}
