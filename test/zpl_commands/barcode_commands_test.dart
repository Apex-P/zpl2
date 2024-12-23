import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  group('Code128Barcode', () {
    test('Default values', () {
      expect(
        const Code128Barcode().zpl,
        '^BCN,,Y,N,,',
      );
    });

    test('Non-default values', () {
      expect(
        const Code128Barcode(
          orientation: ZplOrientation.inverted,
          barcodeHeight: 80,
          printInterpretationLineAboveCode: true,
        ).zpl,
        '^BCI,80,Y,Y,,',
      );
    });
  });

  group('ZplBarcodeFieldDefault', () {
    test('Default values', () {
      expect(
        ZplBarcodeFieldDefault().zpl,
        '^BY,,',
      );
    });

    test('Non-default values', () {
      expect(
        ZplBarcodeFieldDefault(
          moduleWidth: 5,
          wideToNarrowBarRatio: Decimal.parse('2.4'),
          barcodeHeight: 100,
        ).zpl,
        '^BY5,2.4,100',
      );
    });
  });
}
