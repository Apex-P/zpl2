import '../zpl_commands/basic.dart';
import '../zpl_commands/text_commands.dart';
import 'zpl_element.dart';

class ZplText extends ZplElement {
  const ZplText(
    this.text, {
    required this.x,
    required this.y,
    this.style = const ZplTextStyle(),
  });

  final String text;

  final int x;

  final int y;

  final ZplTextStyle style;

  FieldOrigin get _fieldOrigin => FieldOrigin(x, y);

  @override
  String toZpl() {
    return '${_fieldOrigin.zpl}${style.zpl}^FD$text^FS';
  }

  @override
  List<Object?> get props => [
        text,
        x,
        y,
        style,
      ];
}
