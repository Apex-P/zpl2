import 'package:equatable/equatable.dart';

import '../zpl_elements/basic.dart';

/// Put many [ZplElement]s onto a single [ZplLabel].
///
/// This is what you typically send to the printer.
sealed class ZplLabel extends Equatable {
  const ZplLabel({
    required this.children,
    required this.width,
    required this.height,
    required this.margins,
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
  List<Object?> get props => [children, width, height, margins];
}

class ZplRectangleLabel extends ZplLabel {
  const ZplRectangleLabel({
    required super.children,
    required super.width,
    required super.height,
    super.margins = const ZplLabelMargins.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
  });
}

class ZplBarbellLabel extends ZplLabel {
  const ZplBarbellLabel({
    required super.children,
    required super.width,
    required super.height,
    super.margins = const ZplBarbellLabelMargins.symmetric(
      outerHorizontal: 20,
      innerHorizontal: 20,
      vertical: 15,
    ),
  });
}

/// Describes the desired margins of the [ZplLabel].
///
/// The unit of all of the margin attributes are dots.
class ZplLabelMargins extends Equatable {
  const ZplLabelMargins({
    required this.topMargin,
    required this.rightMargin,
    required this.bottomMargin,
    required this.leftMargin,
  });

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

  const ZplLabelMargins.symmetric({int horizontal = 0, int vertical = 0})
    : topMargin = horizontal,
      bottomMargin = horizontal,
      rightMargin = vertical,
      leftMargin = vertical;

  final int topMargin;

  final int rightMargin;

  final int bottomMargin;

  final int leftMargin;

  @override
  List<Object?> get props => [topMargin, rightMargin, bottomMargin, leftMargin];
}

class ZplBarbellLabelMargins extends ZplLabelMargins {
  const ZplBarbellLabelMargins.only({
    super.topMargin = 0,
    super.bottomMargin = 0,
    super.leftMargin = 0,
    super.rightMargin = 0,
    this.middleLeftwardMargin = 0,
    this.middleRightwardMargin = 0,
  });

  const ZplBarbellLabelMargins.symmetric({
    int outerHorizontal = 0,
    int innerHorizontal = 0,
    int vertical = 0,
  }) : middleLeftwardMargin = innerHorizontal,
       middleRightwardMargin = innerHorizontal,
       super(
         bottomMargin: vertical,
         topMargin: vertical,
         leftMargin: outerHorizontal,
         rightMargin: outerHorizontal,
       );

  /// The margin from the middle "barbell handel" to the left.
  final int middleLeftwardMargin;

  /// The margin from the middle "barbell handel" to the right.
  final int middleRightwardMargin;

  @override
  List<Object?> get props =>
      super.props..addAll([middleLeftwardMargin, middleRightwardMargin]);
}
