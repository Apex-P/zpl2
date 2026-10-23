import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplBarcode.toZpl()]', () {
    const data = 'weE9Woo123';
    const fo = FieldOrigin(300, 50, alignment: ZplAlignment.right);
    expect(
      ZplBarcode(data, x: fo.x, y: fo.y, alignment: fo.alignment).toZpl(),
      '${fo.zpl}'
      '${ZplBarcodeFieldDefault()}${const Code128Barcode()}'
      '^FH^FD$data^FS',
    );
  });

  test('[ZplBarcode.toZpl] hex-escapes its data', () {
    const fo = FieldOrigin(0, 0);
    expect(
      ZplBarcode('a^b~c_d', x: fo.x, y: fo.y).toZpl(),
      '${fo.zpl}'
      '${ZplBarcodeFieldDefault()}${const Code128Barcode()}'
      '^FH^FDa_5Eb_7Ec_5Fd^FS',
    );
  });

  Matcher throwsUnencodable(String data, String message) {
    return throwsA(
      isA<ArgumentError>()
          .having((error) => error.name, 'name', 'data')
          .having((error) => error.invalidValue, 'invalidValue', data)
          .having((error) => error.message, 'message', message),
    );
  }

  group('[ZplBarcode] with Code 128', () {
    ZplBarcode buildBarcode(String data) {
      return ZplBarcode(data, x: 0, y: 0);
    }

    test('accepts every ASCII character', () {
      final ascii = String.fromCharCodes(List.generate(0x80, (i) => i));
      expect(() => buildBarcode(ascii), returnsNormally);
    });

    test('rejects U+0080, the first character after ASCII', () {
      expect(
        () => buildBarcode('\u{80}'),
        throwsUnencodable('\u{80}', 'Code 128 cannot encode "\u{80}"'),
      );
    });

    test('rejects a non-ASCII character after ASCII ones', () {
      expect(
        () => buildBarcode('abc\u{E9}'),
        throwsUnencodable('abc\u{E9}', 'Code 128 cannot encode "\u{E9}"'),
      );
    });

    test('rejects a character above U+00FF', () {
      expect(
        () => buildBarcode('\u{17E}'),
        throwsUnencodable('\u{17E}', 'Code 128 cannot encode "\u{17E}"'),
      );
    });

    test('names a character outside the Basic Multilingual Plane whole', () {
      expect(
        () => buildBarcode('\u{1F600}'),
        throwsUnencodable('\u{1F600}', 'Code 128 cannot encode "\u{1F600}"'),
      );
    });
  });

  group('[ZplBarcode] with Code 39', () {
    const code39Characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ -.\$/+%';

    ZplBarcode buildBarcode(String data) {
      return ZplBarcode(data, x: 0, y: 0, barcodeType: const Code39Barcode());
    }

    test('accepts every Code 39 character', () {
      expect(() => buildBarcode(code39Characters), returnsNormally);
    });

    test('rejects every other ASCII character', () {
      for (var codeUnit = 0; codeUnit < 0x80; codeUnit++) {
        final character = String.fromCharCode(codeUnit);
        if (!code39Characters.contains(character)) {
          expect(
            () => buildBarcode(character),
            throwsUnencodable(character, 'Code 39 cannot encode "$character"'),
            reason: 'U+${codeUnit.toRadixString(16).toUpperCase()}',
          );
        }
      }
    });

    test('rejects a lowercase letter after valid characters', () {
      expect(
        () => buildBarcode('ABCa'),
        throwsUnencodable('ABCa', 'Code 39 cannot encode "a"'),
      );
    });

    test('rejects a non-ASCII character', () {
      expect(
        () => buildBarcode('\u{C9}'),
        throwsUnencodable('\u{C9}', 'Code 39 cannot encode "\u{C9}"'),
      );
    });
  });
}
