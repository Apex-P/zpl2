import 'package:meta/meta.dart';

import 'basic.dart';
import 'zpl_font.dart';

@immutable
class ZplTextStyle extends ZplCommand {
  const ZplTextStyle({
    this.font = const ZplFont(),
    this.fontSize = 24,
    this.orientation = ZplOrientation.normal,
  });

  final ZplFont font;

  final int fontSize;

  final ZplOrientation orientation;

  @override
  String get zpl => '^A${font.zpl}${orientation.zpl},$fontSize';

  @override
  List<Object?> get props => [
        font,
        fontSize,
        orientation,
      ];
}
