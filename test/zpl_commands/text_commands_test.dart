import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  test('[ZplTextStyle.zpl]', () {
    expect(
      ZplTextStyle(
        font: ZplFont.helvetica(),
        fontSize: 32,
        orientation: ZplOrientation.rotated,
      ).zpl,
      '^A0R,32',
    );
  });
}
