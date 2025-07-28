part of '../zpl_elements/zpl_text.dart';

@immutable
class ZplTextStyle extends ZplCommand {
  const ZplTextStyle({
    this.font = const ZplFont(),
    this.fontSize = 24,
    this.orientation = ZplOrientation.normal,
  });

  final ZplFont font;

  /// Font size in dots.
  final int fontSize;

  final ZplOrientation orientation;

  @override
  List<String> get commandParams => [
        orientation.zpl,
        fontSize.toString(),
      ];

  @override
  String get commandPrefix => 'A${font.zpl}';

  @useResult
  ZplTextStyle copyWith({
    ZplFont Function()? font,
    int Function()? fontSize,
    ZplOrientation Function()? orientation,
  }) =>
      ZplTextStyle._(
        font: font != null ? font() : this.font,
        fontSize: fontSize != null ? fontSize() : this.fontSize,
        orientation: orientation != null ? orientation() : this.orientation,
      );

  const ZplTextStyle._({
    required this.font,
    required this.fontSize,
    required this.orientation,
  });

  @override
  List<Object?> get props => [
        font,
        fontSize,
        orientation,
      ];
}
