part of '../zpl_elements/zpl_barcode.dart';

/// "Used to change the default values for the module width (in dots), the wide
/// bar to narrow bar width ratio, and the bar code height (in dots)."
/// - ZPL II Programming guide (PDF p. 123)
class ZplBarcodeFieldDefault extends ZplCommand {
  ZplBarcodeFieldDefault({
    this.moduleWidth,
    this.wideToNarrowBarRatio,
    this.barcodeHeight,
  }) : assert(wideToNarrowBarRatio == null || wideToNarrowBarRatio.scale <= 1),
       assert(moduleWidth == null || (moduleWidth >= 1 && moduleWidth <= 10));

  /// Width in dots (of I guess the smallest barcode unit?)
  final int? moduleWidth;

  /// The ratio of the width of wide bars to narrow bars.
  ///
  /// Acceptable values are 2.0 to 3.0 in 0.1 increments.
  final Decimal? wideToNarrowBarRatio;

  /// Height of the barcode in dots.
  final int? barcodeHeight;

  @override
  List<String> get commandParams => [
    moduleWidth.nullToEmptyString(),
    wideToNarrowBarRatio.nullToEmptyString(),
    barcodeHeight.nullToEmptyString(),
  ];

  @override
  String get commandPrefix => 'BY';

  @override
  List<Object?> get props => [moduleWidth, wideToNarrowBarRatio, barcodeHeight];
}

sealed class ZplBarcodeType extends ZplCommand {
  const ZplBarcodeType({
    this.orientation = ZplOrientation.normal,
    this.barcodeHeight,
    this.printInterpretationLine = true,
    this.printInterpretationLineAboveCode = false,
  }) : assert(
         barcodeHeight == null ||
             (barcodeHeight >= 1 && barcodeHeight <= 32000),
       );

  final ZplOrientation orientation;

  /// The height of this barcode in dots.
  ///
  /// Acceptable values between 1 to 32000. If null, set by
  /// [ZplBarcode.barcodeFieldStyle]'s
  /// [ZplBarcodeFieldDefault.barcodeHeight].
  final int? barcodeHeight;

  final bool printInterpretationLine;

  ZplBoolean get _printInterpretationLine =>
      ZplBoolean(printInterpretationLine);

  final bool printInterpretationLineAboveCode;

  ZplBoolean get _printInterpretationLineAboveCode =>
      ZplBoolean(printInterpretationLineAboveCode);

  // Using these one-letter getters to make it easier to follow along with the
  // "ZPL II Programming Guide".
  @override
  List<String> get commandParams => [_o, _h, _f, _g, _e, _m];

  String get _o => orientation.zpl;
  String get _h => barcodeHeight.nullToEmptyString();
  String get _f => _printInterpretationLine.zpl;
  String get _g => _printInterpretationLineAboveCode.zpl;
  String get _e => '';
  String get _m => '';

  @override
  List<Object?> get props => [
    orientation,
    barcodeHeight,
    printInterpretationLine,
    printInterpretationLineAboveCode,
  ];
}

class Code128Barcode extends ZplBarcodeType {
  const Code128Barcode({
    super.orientation,
    super.barcodeHeight,
    super.printInterpretationLine,
    super.printInterpretationLineAboveCode,
  });

  @override
  String get commandPrefix => 'BC';
}

class Code39Barcode extends ZplBarcodeType {
  const Code39Barcode({
    super.orientation,
    super.barcodeHeight,
    super.printInterpretationLine,
    super.printInterpretationLineAboveCode,
  });

  @override
  String get commandPrefix => 'B3';
}
