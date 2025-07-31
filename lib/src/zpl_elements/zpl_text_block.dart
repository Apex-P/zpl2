library zpl_text_block;

import '../../zpl2.dart';

/// Similar to [ZplText] but used to wrap the given text within a certain
/// width.
class ZplTextBlock extends ZplText {
  ZplTextBlock(
    super.text, {
    required super.x,
    required super.y,
    required this.blockStyle,

    /// The alignment of this element's origin (defined by [x] an [y]).
    ///
    /// For the alignment of the actual [text] within this block, see
    /// [ZplTextBlockCommand.textJustification]
    super.alignment = ZplAlignment.left,
    super.style,
  });

  final ZplTextBlockStyle blockStyle;

  @override
  List<ZplCommand> get zplCommands => [blockStyle, ...super.zplCommands];

  @override
  List<Object?> get props => super.props..addAll([style]);
}

/// Required arguments for the behavior of a [ZplTextBlock].
class ZplTextBlockStyle extends ZplCommand {
  const ZplTextBlockStyle({
    required this.blockWidth,
    required this.maxLines,
    this.linePadding = 0,
    this.textJustification = ZplTextBlockJustification.left,
    this.hangingIndent = 0,
  });

  /// The width of the text block in dots.
  ///
  /// Can be between 0 and the width of the label.
  final int blockWidth;

  /// The maximum number of lines of text in this block.
  ///
  /// Acceptable values: 1 to 9999.
  final int maxLines;

  /// Added or removed space between lines (in dots).
  ///
  /// Acceptable values: -9999 to 9999 (positive values add space, negative
  /// values delete space).
  final int linePadding;

  final ZplTextBlockJustification textJustification;

  /// The size of the hanging indent (in dots) of the second and subsequent
  /// lines.
  final int hangingIndent;

  @override
  List<String> get commandParams => [
    blockWidth.toString(),
    maxLines.toString(),
    linePadding.toString(),
    textJustification.zpl,
    hangingIndent.toString(),
  ];

  @override
  String get commandPrefix => 'FB';

  @override
  List<Object?> get props => [
    blockWidth,
    maxLines,
    linePadding,
    textJustification,
    hangingIndent,
  ];
}

enum ZplTextBlockJustification {
  left('L'),
  center('C'),
  right('R'),
  justified('J');

  final String zpl;

  const ZplTextBlockJustification(this.zpl);
}
