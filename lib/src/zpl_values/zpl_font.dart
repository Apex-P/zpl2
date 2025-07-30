part of '../zpl_elements/zpl_text.dart';

/// Sets the font of a [ZplText].
class ZplFont extends ZplValue {
  const ZplFont() : _font = ZebraFonts.helvetica;

  const ZplFont.zebraFont(this._font);

  final ZebraFonts _font;

  factory ZplFont.helvetica() => const ZplFont.zebraFont(ZebraFonts.helvetica);

  @override
  String get zpl => _font.zplValue;

  @override
  List<Object?> get props => [_font];
}

enum ZebraFonts {
  helvetica('0');

  final String zplValue;

  const ZebraFonts(this.zplValue);
}
