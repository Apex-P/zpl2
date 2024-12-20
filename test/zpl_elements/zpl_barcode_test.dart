import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplBarcode.toZpl()]', () {
    const data = 'weE9Woo123';
    expect(
      const ZplBarcode(data, x: 300, y: 50).toZpl(),
      '^FO300,50'
      '${ZplBarcodeFieldDefault()}${const Code128Barcode()}'
      '^FD$data^FS',
    );
  });
}
