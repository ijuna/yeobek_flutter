abstract interface class Repository<T> {
  Future<List<T>> fetchAll();
}
