import 'package:equatable/equatable.dart';

import '../zpl_elements/basic.dart';

/// Put many [ZplElement]s onto a single [ZplLabel].
///
/// This is what you typically send to the printer.
class ZplLabel extends Equatable {
  const ZplLabel({
    required this.children,
    required this.width,
    required this.height,
    this.margins = const ZplLabelMargins.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
  });

  final List<ZplElement> children;

  /// Width of the label in dots.
  final int width;

  /// Height of the label in dots.
  final int height;

  /// Currently just used by implementations of the [ZplLabel] to help define
  /// absolute positions of [children].
  final ZplLabelMargins margins;

  /// The actual ZPL sent to the printer.
  String toZpl() {
    return '^XA${children.map((child) => child.toZpl()).join()}^XZ';
  }

  /// The y-value (in dots) of the location of the top margin.
  int get topMargin => margins.topMargin;

  /// The x-value (in dots) of the location of the right margin.
  int get rightMargin => width - margins.rightMargin;

  /// The y-value (in dots) of the location of the bottom margin.
  int get bottomMargin => height - margins.bottomMargin;

  /// The x-value (in dots) of the location of the left margin.
  int get leftMargin => margins.leftMargin;

  @override
  List<Object?> get props => [
        children,
        width,
        height,
        margins,
      ];
}

/// Describes the desired margins of the [ZplLabel].
///
/// The unit of all of the margin attributes are dots.
class ZplLabelMargins extends Equatable {
  const ZplLabelMargins.only({
    this.topMargin = 0,
    this.rightMargin = 0,
    this.bottomMargin = 0,
    this.leftMargin = 0,
  });

  const ZplLabelMargins.all(int margin)
      : topMargin = margin,
        rightMargin = margin,
        bottomMargin = margin,
        leftMargin = margin;

  const ZplLabelMargins.symmetric({
    int horizontal = 0,
    int vertical = 0,
  })  : topMargin = horizontal,
        bottomMargin = horizontal,
        rightMargin = vertical,
        leftMargin = vertical;

  final int topMargin;

  final int rightMargin;

  final int bottomMargin;

  final int leftMargin;

  @override
  List<Object?> get props => [
        topMargin,
        rightMargin,
        bottomMargin,
        leftMargin,
      ];
}
