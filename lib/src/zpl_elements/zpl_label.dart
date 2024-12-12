import 'zpl_element.dart';

/// The "top level" [ZplElement] that is typically sent to a printer.
class ZplLabel extends ZplElement {
  const ZplLabel({
    required this.width,
    required this.height,
    required this.children,
  });

  final int width;

  final int height;

  final List<ZplElement> children;

  @override
  String toZpl() {
    return '^XA${children.map((child) => child.toZpl()).join()}^XZ';
  }
}
