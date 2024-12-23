import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/src/zpl_printer/zpl_label.dart';
import 'package:zpl2/src/zpl_printer/zpl_printer.dart';

ZplNetworkPrinter buildNetworkPrinter() {
  return ZplNetworkPrinter(
    networkAddress: InternetAddress('0.0.0.0'),
    port: 9100,
  );
}

void main() {
  test('[ZplNetworkPrinter.labelsToZpl]', () {
    final printer = buildNetworkPrinter();
    const label = ZplLabel(children: [], width: 0, height: 0);

    expect(
      printer.labelsToZpl([label]),
      label.toZpl(),
    );
    expect(
      printer.labelsToZpl([label, label]),
      '${label.toZpl()}${label.toZpl()}',
    );
    expect(
      printer.labelsToZpl([label, label, label]),
      '${label.toZpl()}${label.toZpl()}${label.toZpl()}',
    );
  });
}
