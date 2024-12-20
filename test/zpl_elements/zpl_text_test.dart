import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplText.toZpl]', () {
    const fo = FieldOrigin(34, 98);
    final text = ZplText(
      '12/12/2024',
      x: fo.x,
      y: fo.y,
      style: ZplTextStyle(
        font: ZplFont.helvetica(),
        fontSize: 16,
      ),
    );
    expect(text.toZpl(), '${fo.zpl}^A0N,16^FD12/12/2024^FS');
  });
}
