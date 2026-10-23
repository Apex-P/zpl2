import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/src/extensions/null_to_empty_string.dart';
import 'package:zpl2/zpl2.dart';

class MockZplCommand extends ZplCommand {
  const MockZplCommand({this.a, this.b, this.c});

  final int? a;

  final int? b;

  final int? c;

  @override
  List<String> get commandParams => [
    a.nullToEmptyString(),
    b.nullToEmptyString(),
    c.nullToEmptyString(),
  ];

  @override
  String get commandPrefix => 'XX';

  @override
  List<Object?> get props => [a, b, c];
}

void main() {
  test('Params are comma separated; null params result in empty string', () {
    expect(const MockZplCommand().zpl, '^XX,,');
    expect(const MockZplCommand(b: 42).zpl, '^XX,42,');
    expect(const MockZplCommand(a: 1, c: 3).zpl, '^XX1,,3');
    expect(const MockZplCommand(a: 1, b: 2, c: 3).zpl, '^XX1,2,3');
  });

  group('FieldOrigin', () {
    test('Default values', () {
      expect(const FieldOrigin(419, 88).zpl, '^FO419,88,0');
    });

    test('Non-default values', () {
      expect(
        const FieldOrigin(6, 7, alignment: ZplAlignment.right).zpl,
        '^FO6,7,1',
      );
    });
  });

  group('FieldData', () {
    test('Data with nothing to escape', () {
      expect(const FieldData('Hello, 123!').zpl, '^FH^FDHello, 123!');
    });

    test('Empty data', () {
      expect(const FieldData('').zpl, '^FH^FD');
    });

    test('Caret is hex-escaped', () {
      expect(const FieldData('a^b').zpl, '^FH^FDa_5Eb');
    });

    test('Tilde is hex-escaped', () {
      expect(const FieldData('a~b').zpl, '^FH^FDa_7Eb');
    });

    test('Underscore is hex-escaped', () {
      expect(const FieldData('a_b').zpl, '^FH^FDa_5Fb');
    });

    test('Every occurrence is hex-escaped', () {
      expect(const FieldData('^^~~__').zpl, '^FH^FD_5E_5E_7E_7E_5F_5F');
    });

    test('Escape sequences in the data are themselves escaped', () {
      expect(const FieldData('_5E').zpl, '^FH^FD_5F5E');
    });

    test('Commands in the data are escaped', () {
      expect(const FieldData('^FS^XZ~JR').zpl, '^FH^FD_5EFS_5EXZ_7EJR');
    });

    test('Backslash is not escaped', () {
      expect(const FieldData(r'a\&b').zpl, r'^FH^FDa\&b');
    });

    test('Non-ASCII characters are not escaped', () {
      expect(
        const FieldData('\u{15E}\u{17E}\u{1F600}').zpl,
        '^FH^FD\u{15E}\u{17E}\u{1F600}',
      );
    });
  });
}
