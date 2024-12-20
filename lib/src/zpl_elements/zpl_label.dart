import 'package:equatable/equatable.dart';

import 'basic.dart';

/// Put many [ZplElement]s onto a single [ZplLabel].
///
/// This is what you typically send to the printer.
class ZplLabel extends Equatable {
  const ZplLabel({
    required this.width,
    required this.height,
    required this.children,
  });

  // Width of the label in dots.
  final int width;

  // Height of the label in dots.
  final int height;

  final List<ZplElement> children;

  /// The actual ZPL sent to the printer.
  String toZpl() {
    return '^XA${children.map((child) => child.toZpl()).join()}^XZ';
  }

  @override
  List<Object?> get props => [
        width,
        height,
        children,
      ];
}
