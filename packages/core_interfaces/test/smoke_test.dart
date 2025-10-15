import 'package:test/test.dart';
import 'package:core_interfaces/core_interfaces.dart';

class MemoryRepo<T> implements Repository<T> {
  final List<T> data;
  MemoryRepo(this.data);
  @override
  Future<List<T>> fetchAll() async => data;
}

void main() {
  test('Repository interface can be implemented', () async {
    final repo = MemoryRepo<int>([1, 2]);
    expect(await repo.fetchAll(), [1, 2]);
  });
}
