import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplText.toZpl]', () {
    const fo = FieldOrigin(34, 98);
    final text = ZplText(
      '12/12/2024',
      x: fo.x,
      y: fo.y,
      style: ZplTextStyle(font: ZplFont.helvetica(), fontSize: 16),
    );
    expect(text.toZpl(), '${fo.zpl}^A0N,16^FH^FD12/12/2024^FS');
  });

  test('[ZplText.toZpl] hex-escapes its text', () {
    const fo = FieldOrigin(0, 0);
    final text = ZplText('a^b~c_d', x: fo.x, y: fo.y);
    expect(text.toZpl(), '${fo.zpl}^A0N,24^FH^FDa_5Eb_7Ec_5Fd^FS');
  });

  test('[ZplText.toZpl] keeps line breaks after hex-escaping', () {
    const fo = FieldOrigin(0, 0);
    final text = ZplText('a^\nb', x: fo.x, y: fo.y);
    expect(text.toZpl(), '${fo.zpl}^A0N,24^FH^FDa_5E\\&b^FS');
  });
}
