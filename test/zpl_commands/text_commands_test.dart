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

  test('[ZplTextStyle.copyWith]', () {
    const originalStyle = ZplTextStyle();
    expect(
      originalStyle.copyWith(
        fontSize: () => 16,
      ),
      const ZplTextStyle(fontSize: 16),
    );
    expect(
      originalStyle.copyWith(
        font: () => ZplFont.helvetica(),
      ),
      const ZplTextStyle(),
    );
    expect(
      originalStyle.copyWith(
        orientation: () => ZplOrientation.rotated,
      ),
      const ZplTextStyle(orientation: ZplOrientation.rotated),
    );
    expect(
      originalStyle.copyWith(
        fontSize: () => 72,
        orientation: () => ZplOrientation.rotated,
      ),
      const ZplTextStyle(
        fontSize: 72,
        orientation: ZplOrientation.rotated,
      ),
    );
  });
}
