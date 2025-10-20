import 'package:flutter_test/flutter_test.dart';
import 'package:features/features.dart';

void main() {
  test('Feature screens are constructible', () {
    expect(const ArtistScreen(), isNotNull);
    expect(const ArtworksScreen(), isNotNull);
    expect(const BoardScreen(), isNotNull);
  });
}
