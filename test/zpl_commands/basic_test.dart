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
}
