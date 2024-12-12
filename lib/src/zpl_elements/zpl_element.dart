import 'package:meta/meta.dart';

/// Level of abstraction closest to raw ZPL commands.
///
/// [toZpl] is exactly what gets sent to the printer.
@immutable
abstract class ZplElement {
  const ZplElement();

  /// Get the actual ZPL to send to the printer.
  String toZpl();
}
