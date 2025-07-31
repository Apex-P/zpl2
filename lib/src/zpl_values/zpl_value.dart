import 'package:equatable/equatable.dart';

/// The simplest kind of ZPL: really just a string of characters whose meaning
/// is given by the commands around it.
abstract class ZplValue extends Equatable {
  const ZplValue();

  String get zpl;
}

class ZplBoolean extends ZplValue {
  const ZplBoolean(this.value);

  final bool value;

  @override
  String get zpl => value ? 'Y' : 'N';

  @override
  List<Object?> get props => [value];
}
