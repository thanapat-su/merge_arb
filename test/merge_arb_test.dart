import 'package:intl/locale.dart';
import 'package:merge_arb/src/merge_arb_builder.dart';
import 'package:test/test.dart';

void main() {
  group('getLocaleFromPath', () {
    test('file_en.arb -> en', () {
      expect(getLocaleFromPath('path/file_en.arb'), 'en');
    });

    test('file_test.arb -> null', () {
      expect(getLocaleFromPath('path/file_test.arb'), null);
    });

    test('file_test_en.arb -> en', () {
      expect(getLocaleFromPath('path/file_test_en.arb'), 'en');
    });

    test('file_test_en_US.arb -> en_US', () {
      expect(getLocaleFromPath('path/file_test_en_US.arb'), 'en_US');
    });

    test('file_test_es_419.arb -> en_US', () {
      expect(getLocaleFromPath('path/file_test_es_419.arb'), 'es_419');
    });

    test('file_test_ess_419.arb -> en_US', () {
      expect(getLocaleFromPath('path/file_test_ess_419.arb'), null);
    });
  });
}
