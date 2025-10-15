import '../../catalog/domain/catalog_entity.dart';

abstract interface class CatalogRepository {
  Future<List<CatalogEntity>> fetch();
}
