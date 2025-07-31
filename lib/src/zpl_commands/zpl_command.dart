import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../zpl_elements/zpl_element.dart';

/// Components of [ZplElement]s.
@immutable
abstract class ZplCommand extends Equatable {
  const ZplCommand();

  /// This command in ZPL.
  ///
  /// You typically do not need to override this; the [zpl] getter is
  /// responsible for prepending the caret ('^') before the [commandPrefix],
  /// which is then followed by the list of [commandParams] joined together by
  /// commas.
  String get zpl => '^$commandPrefix${commandParams.join(',')}';

  /// The letters following a caret symbol identifying this particular command.
  ///
  /// Do NOT include the caret; it is included automatically in [zpl].
  String get commandPrefix;

  /// The list of individual parameters that follow the [commandPrefix].
  List<String> get commandParams;

  @override
  String toString() => zpl;
}

/// Sets the position of its field ([ZplElement]).
///
/// [x] and [y] are the coordinates for the top left of the current field.
class FieldOrigin extends ZplCommand {
  const FieldOrigin(this.x, this.y, {this.alignment = ZplAlignment.left});

  final int x;

  final int y;

  final ZplAlignment alignment;

  @override
  List<String> get commandParams => [x.toString(), y.toString(), alignment.zpl];

  @override
  String get commandPrefix => 'FO';

  @override
  List<Object?> get props => [x, y, alignment];
}

/// Used to separate consecutive [ZplElement]s.
class FieldSeparator extends ZplCommand {
  const FieldSeparator();

  @override
  List<String> get commandParams => [];

  @override
  String get commandPrefix => 'FS';

  @override
  List<Object?> get props => [];
}

/// Used in elements such as [ZplText] to print element-specific data to a
/// label.
class FieldData extends ZplCommand {
  const FieldData(this.data);

  final String data;

  @override
  List<String> get commandParams => [data];

  @override
  String get commandPrefix => 'FD';

  @override
  List<Object?> get props => [data];
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

enum ZplAlignment {
  left('0'),
  right('1'),
  automatic('2');

  const ZplAlignment(this.zpl);

  /// The ZPL representing this alignment.
  final String zpl;

  @override
  String toString() => zpl;
}
