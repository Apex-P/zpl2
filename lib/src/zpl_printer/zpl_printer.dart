import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../zpl2.dart';

sealed class ZplPrinter extends Equatable {
  const factory ZplPrinter.network({
    required InternetAddress networkAddress,
    required int port,
  }) = ZplNetworkPrinter;

  Future<void> print(ZplLabel zplElement);
}

/// Sends [ZplLabel]s over the network to be printed.
@immutable
class ZplNetworkPrinter with EquatableMixin implements ZplPrinter {
  /// Zebra printers usually listen to port 9100 by default.
  const ZplNetworkPrinter({
    required this.networkAddress,
    required this.port,
  });

  final InternetAddress networkAddress;

  final int port;

  /// Throws a [SocketException] upon failure to connect to the printer.
  @override
  Future<void> print(ZplLabel zplElement) async {
    final socket = await Socket.connect(networkAddress, port);
    socket.add(zplElement.toZpl().codeUnits);
    await socket.flush();
    await socket.close();
  }

  @override
  List<Object?> get props => [
        networkAddress,
        port,
      ];
}
