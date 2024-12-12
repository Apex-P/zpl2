import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplText.toZpl]', () {
    final text = ZplText(
      '12/12/2024',
      x: 34,
      y: 98,
      style: ZplTextStyle(
        font: ZplFont.helvetica(),
        fontSize: 16,
      ),
    );
    expect(text.toZpl(), '^FO34,98^A0N,16^FD12/12/2024^FS');
  });
}
