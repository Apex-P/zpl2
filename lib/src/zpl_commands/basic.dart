import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../zpl_elements/zpl_element.dart';

/// Components of [ZplElement]s.
@immutable
abstract class ZplCommand extends Equatable {
  const ZplCommand();

  String get zpl;

  @override
  String toString() => zpl;
}

/// Sets the position of its field ([ZplElement]).
///
/// [x] and [y] are the coordinates for the top left of the current field.
class FieldOrigin extends ZplCommand {
  const FieldOrigin(this.x, this.y);

  final int x;

  final int y;

  @override
  String get zpl => '^FO$x,$y';

  @override
  List<Object?> get props => [
        x,
        y,
      ];
}

enum ZplOrientation {
  /// Right-side-up.
  normal('N'),

  /// Upside-down
  inverted('I'),

  /// Rotated 90 degrees clockwise
  rotated('R'),

  /// Rotated 90 degrees counter-clockwise
  rotatedBack('B');

  const ZplOrientation(this.zpl);

  /// The ZPL representing this orientation.
  final String zpl;

  @override
  String toString() => zpl;
}
