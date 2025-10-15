import 'package:flutter_test/flutter_test.dart';
import 'package:language/language.dart';

void main() {
  test('AppLang delegates/supportedLocales exist', () {
    expect(AppLang.localizationsDelegates, isNotNull);
    expect(AppLang.supportedLocales.isNotEmpty, isTrue);
  });
}
