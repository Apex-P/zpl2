import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'zpl_label.dart';

sealed class ZplPrinter extends Equatable {
  const ZplPrinter();

  const factory ZplPrinter.network({
    required InternetAddress networkAddress,
    required int port,
    Duration connectTimeout,
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
    this.connectTimeout = const Duration(seconds: 10),
  });

  final InternetAddress networkAddress;

  final int port;

  /// How long [printAll] waits to connect to the printer before giving up.
  final Duration connectTimeout;

  /// Throws a [SocketException] upon failure to connect to the printer,
  /// including when it does not connect within [connectTimeout].
  ///
  /// Builds every label before connecting, so a label that throws never opens
  /// a connection.
  @override
  Future<void> printAll(Iterable<ZplLabel> labels) async {
    final zplBytes = utf8.encode(labelsToZpl(labels));
    final socket = await Socket.connect(
      networkAddress,
      port,
      timeout: connectTimeout,
    );
    try {
      socket.add(zplBytes);
      await socket.flush();
      await socket.close();
    } catch (_) {
      socket.destroy();
      rethrow;
    }
  }

  String labelsToZpl(Iterable<ZplLabel> labels) {
    final zplByLabel = labels.map((element) => element.toZpl());
    return zplByLabel.join();
  }

  @override
  List<Object?> get props => [networkAddress, port, connectTimeout];
}
