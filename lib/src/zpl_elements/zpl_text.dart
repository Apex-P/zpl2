library zpl_text;

import 'package:meta/meta.dart';

import '../zpl_commands/basic.dart';
import '../zpl_values/basic.dart';
import 'basic.dart';

part '../zpl_commands/text_commands.dart';
part '../zpl_values/zpl_font.dart';

class ZplText extends ZplDataElement {
  const ZplText(
    String text, {
    required super.x,
    required super.y,
    super.alignment = ZplAlignment.left,
    this.style = const ZplTextStyle(),
  }) : super(elementData: text);

  final ZplTextStyle style;

  @override
  List<ZplCommand> get zplCommands => [
        style,
      ];

  @override
  List<Object?> get props => super.props
    ..addAll([
      style,
    ]);
}
