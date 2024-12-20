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
      '^FD$data^FS',
    );
  });
}
