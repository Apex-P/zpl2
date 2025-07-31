import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../zpl_commands/zpl_command.dart';
import 'zpl_barcode.dart';
import 'zpl_text.dart';

/// Level of abstraction closest to raw ZPL commands.
///
/// [toZpl] is exactly what gets sent to the printer.
@immutable
abstract class ZplElement extends Equatable {
  const ZplElement({required this.x, required this.y, required this.alignment});

  final int x;

  final int y;

  final ZplAlignment alignment;

  List<ZplCommand> get zplCommands;

  FieldOrigin get fieldOrigin => FieldOrigin(x, y, alignment: alignment);

  /// Get the actual ZPL to send to the printer.
  ///
  /// Wraps every command in [zplCommands] in a [fieldOrigin] and
  /// [FieldSeparator].
  ///
  /// You typically do not need to override this.
  String toZpl() {
    return '$_elementStart$_zplCommandsString$_elementEnd';
  }

  String get _elementStart => fieldOrigin.zpl;

  String get _elementEnd => const FieldSeparator().zpl;

  String get _zplCommandsString =>
      zplCommands.map((command) => command.zpl).join();

  @override
  List<Object?> get props => [x, y, alignment];
}

/// A [ZplElement] with a [FieldData] command (e.g., [ZplText], [ZplBarcode]).
abstract class ZplDataElement extends ZplElement {
  const ZplDataElement({
    required this.elementData,
    required super.x,
    required super.y,
    required super.alignment,
  });

  /// Data used to build [fieldData].
  final String elementData;

  FieldData get fieldData => FieldData(elementData);

  @override
  String get _zplCommandsString =>
      [...zplCommands, fieldData].map((command) => command.zpl).join();

  @override
  List<Object?> get props => super.props..addAll([elementData]);
}
