import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

/// Just an element with empty ZPL.
class EmptyZplElement extends ZplElement {
  const EmptyZplElement();

  @override
  String toZpl() => '';
}

ZplLabel buildZplLabel(
  List<ZplElement> children, {
  int width = 0,
  int height = 0,
}) {
  return ZplLabel(width: width, height: height, children: children);
}

void main() {
  group('Label adds ZPL "begin" and "end" commands.', () {
    test('Label has no children', () {
      final label = buildZplLabel([]);
      expect(label.toZpl(), '^XA^XZ');
    });

    test('Label children ZPL result is empty', () {
      final label = buildZplLabel([const EmptyZplElement()]);
      expect(label.toZpl(), '^XA^XZ');
    });

    test('Label with multiple text fields', () {
      const text1 = ZplText('text 1', x: 0, y: 0);
      const text2 = ZplText('text 2', x: 1, y: 2);
      final label = buildZplLabel([text1, text2]);

      expect(
        label.toZpl(),
        '^XA${text1.toZpl()}${text2.toZpl()}^XZ',
      );
    });
  });
}
