import 'package:flutter_test/flutter_test.dart';
import 'package:features/features.dart';

void main() {
  test('Feature screens are constructible', () {
    expect(const ArtistScreen(), isNotNull);
    expect(const CatalogScreen(), isNotNull);
    expect(const PostScreen(), isNotNull);
  });
}
