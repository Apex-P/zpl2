import 'package:decimal/decimal.dart';

import '../extensions/null_to_empty_string.dart';
import '../zpl_commands/basic.dart';
import '../zpl_values/basic.dart';
import 'basic.dart';

part '../zpl_commands/barcode_commands.dart';

class ZplBarcode extends ZplDataElement {
  const ZplBarcode(
    String data, {
    required super.x,
    required super.y,
    this.barcodeFieldStyle,
    this.barcodeType = const Code128Barcode(),
  }) : super(elementData: data);

  final ZplBarcodeFieldDefault? barcodeFieldStyle;

  final ZplBarcodeType barcodeType;

  @override
  List<ZplCommand> get zplCommands => [
        barcodeFieldStyle ?? ZplBarcodeFieldDefault(),
        barcodeType,
      ];

  @override
  List<Object?> get props => super.props
    ..addAll([
      barcodeFieldStyle,
      barcodeType,
    ]);
}
