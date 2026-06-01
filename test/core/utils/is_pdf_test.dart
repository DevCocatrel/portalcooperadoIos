import 'dart:convert';

import 'package:cocatrel/core/utils/is_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testa a função isPDF', () {
    test('Deve retornar false quando o parâmetro não for um PDF', () {
      expect(isPdf(utf8.encode("%DOC")), false);
      expect(isPdf(utf8.encode("%PNG")), false);
      expect(isPdf(utf8.encode("%JPEG")), false);
      expect(isPdf(utf8.encode("%TXT")), false);
      expect(isPdf(utf8.encode("%APK")), false);
    });

    test('Deve retornar true quando o parâmetro for um PDF', () {
      expect(isPdf(utf8.encode("%PDF")), true);
    });
  });
}
