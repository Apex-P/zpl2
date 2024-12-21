import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../zpl2.dart';

sealed class ZplPrinter extends Equatable {
  const ZplPrinter();

  const factory ZplPrinter.network({
    required InternetAddress networkAddress,
    required int port,
  }) = ZplNetworkPrinter;

  Future<void> print(ZplLabel label) async {
    return await printAll([label]);
  }

  Future<void> printAll(Iterable<ZplLabel> labels);
}

/// Sends [ZplLabel]s over the network to be printed.
@immutable
class ZplNetworkPrinter extends ZplPrinter {
  /// Zebra printers usually listen to port 9100 by default.
  const ZplNetworkPrinter({
    required this.networkAddress,
    required this.port,
  });

  final InternetAddress networkAddress;

  final int port;

  /// Throws a [SocketException] upon failure to connect to the printer.
  @override
  Future<void> printAll(Iterable<ZplLabel> labels) async {
    final socket = await Socket.connect(networkAddress, port);
    socket.add(labelsToZpl(labels).codeUnits);
    await socket.flush();
    await socket.close();
  }

  String labelsToZpl(Iterable<ZplLabel> labels) {
    final zplByLabel = labels.map((element) => element.toZpl());
    return zplByLabel.join();
  }

  @override
  List<Object?> get props => [
        networkAddress,
        port,
      ];
}
