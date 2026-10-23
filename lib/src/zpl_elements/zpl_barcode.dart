import 'package:decimal/decimal.dart';

import '../extensions/null_to_empty_string.dart';
import '../zpl_commands/zpl_command.dart';
import '../zpl_values/zpl_value.dart';
import 'zpl_element.dart';

part '../zpl_commands/barcode_commands.dart';

class ZplBarcode extends ZplDataElement {
  /// Throws an [ArgumentError] if [barcodeType] cannot encode every character
  /// of [data].
  ZplBarcode(
    String data, {
    required super.x,
    required super.y,
    super.alignment = ZplAlignment.left,
    this.barcodeFieldStyle,
    this.barcodeType = const Code128Barcode(),
  }) : super(elementData: data) {
    for (final character in data.runes) {
      if (!barcodeType._canEncode(character)) {
        final unencodable = String.fromCharCode(character);
        throw ArgumentError.value(
          data,
          'data',
          '${barcodeType._name} cannot encode "$unencodable"',
        );
      }
    }
  }

  final ZplBarcodeFieldDefault? barcodeFieldStyle;

  final ZplBarcodeType barcodeType;

  @override
  List<ZplCommand> get zplCommands => [
    barcodeFieldStyle ?? ZplBarcodeFieldDefault(),
    barcodeType,
  ];

  @override
  List<Object?> get props =>
      super.props..addAll([barcodeFieldStyle, barcodeType]);
}
