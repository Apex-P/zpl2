import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/src/zpl_elements/zpl_barcode.dart';
import 'package:zpl2/src/zpl_elements/zpl_text.dart';
import 'package:zpl2/src/zpl_printer/zpl_label.dart';
import 'package:zpl2/src/zpl_printer/zpl_printer.dart';

/// A TCP server on the loopback interface standing in for a network printer.
class LoopbackPrinter {
  LoopbackPrinter(this._serverSocket);

  final ServerSocket _serverSocket;

  /// A [ZplNetworkPrinter] that sends to this server.
  ZplNetworkPrinter get networkPrinter => ZplNetworkPrinter(
    networkAddress: _serverSocket.address,
    port: _serverSocket.port,
  );

  /// Runs [send] and returns every byte it sent over its one connection.
  Future<List<int>> receiveBytesSentBy(
    Future<void> Function(ZplNetworkPrinter printer) send,
  ) async {
    final connection = _serverSocket.first;
    await send(networkPrinter);
    final socket = await connection;
    final bytes = await socket.fold<List<int>>(
      [],
      (received, chunk) => received..addAll(chunk),
    );
    socket.destroy();
    return bytes;
  }

  /// Whether anything has connected to this server.
  ///
  /// Connects to this server and waits for that connection, which the server
  /// accepts only after every connection made before it.
  Future<bool> hasBeenConnectedTo() async {
    final firstConnection = _serverSocket.first;
    final probe = await Socket.connect(
      _serverSocket.address,
      _serverSocket.port,
    );
    final accepted = await firstConnection;
    final probeWasFirst = accepted.remotePort == probe.port;
    accepted.destroy();
    probe.destroy();
    return !probeWasFirst;
  }

  Future<void> close() async {
    await _serverSocket.close();
  }
}

enum SocketOperation { add, flush, close }

/// A [Socket] that throws [error] from [failingOperation] and records how it
/// was closed.
class FakeSocket implements Socket {
  FakeSocket({this.failingOperation});

  final SocketOperation? failingOperation;

  final error = const SocketException('Fake failure');

  bool isClosed = false;

  bool isDestroyed = false;

  @override
  void add(List<int> data) {
    _throwIfFailing(SocketOperation.add);
  }

  @override
  Future<void> flush() async {
    _throwIfFailing(SocketOperation.flush);
  }

  @override
  Future<void> close() async {
    _throwIfFailing(SocketOperation.close);
    isClosed = true;
  }

  @override
  void destroy() {
    isDestroyed = true;
  }

  void _throwIfFailing(SocketOperation operation) {
    if (operation == failingOperation) {
      throw error;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ZplNetworkPrinter buildNetworkPrinter() {
  return ZplNetworkPrinter(
    networkAddress: InternetAddress('0.0.0.0'),
    port: 9100,
  );
}

void main() {
  test('[ZplNetworkPrinter.labelsToZpl]', () {
    final printer = buildNetworkPrinter();
    const label = ZplRectangleLabel(children: [], width: 0, height: 0);

    expect(printer.labelsToZpl([label]), label.toZpl());
    expect(
      printer.labelsToZpl([label, label]),
      '${label.toZpl()}${label.toZpl()}',
    );
    expect(
      printer.labelsToZpl([label, label, label]),
      '${label.toZpl()}${label.toZpl()}${label.toZpl()}',
    );
  });

  group('[ZplNetworkPrinter] sends', () {
    late LoopbackPrinter printer;

    setUp(() async {
      final serverSocket = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      printer = LoopbackPrinter(serverSocket);
    });

    tearDown(() async {
      await printer.close();
    });

    ZplLabel buildTextLabel(String text) {
      return ZplRectangleLabel(
        children: [ZplText(text, x: 0, y: 0)],
        width: 0,
        height: 0,
      );
    }

    test('the ZPL of a label passed to print', () async {
      final label = buildTextLabel('Hello');

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.print(label),
      );

      expect(utf8.decode(bytes), label.toZpl());
    });

    test('the ZPL of every label passed to printAll, in order', () async {
      final first = buildTextLabel('first');
      final second = buildTextLabel('second');

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.printAll([first, second]),
      );

      expect(utf8.decode(bytes), '${first.toZpl()}${second.toZpl()}');
    });

    test('nothing when printAll is passed no labels', () async {
      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.printAll([]),
      );

      expect(bytes, isEmpty);
    });

    test('characters from U+0080 to U+00FF as UTF-8', () async {
      final label = buildTextLabel('Jos\u{E9} Pe\u{F1}a');

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.print(label),
      );

      expect(utf8.decode(bytes), label.toZpl());
    });

    test('characters above U+00FF as UTF-8', () async {
      final label = buildTextLabel('Bo\u{17E}ena \u{15E}ahin \u{20AC}5');

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.print(label),
      );

      expect(utf8.decode(bytes), label.toZpl());
    });

    test('characters outside the Basic Multilingual Plane as UTF-8', () async {
      final label = buildTextLabel('\u{1F600}');

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.print(label),
      );

      expect(utf8.decode(bytes), label.toZpl());
    });

    test('no caret or tilde that is not in the ZPL', () async {
      // The low bytes of U+015E and U+017E are those of '^' and '~'.
      final label = buildTextLabel('\u{15E}\u{17E}');
      final zpl = label.toZpl();

      final bytes = await printer.receiveBytesSentBy(
        (networkPrinter) => networkPrinter.print(label),
      );

      final caretCount = bytes.where((byte) => byte == 0x5E).length;
      final tildeCount = bytes.where((byte) => byte == 0x7E).length;
      expect(caretCount, '^'.allMatches(zpl).length);
      expect(tildeCount, '~'.allMatches(zpl).length);
    });

    test('nothing, without connecting, when building a label throws', () async {
      // Built lazily, the way a caller mapping its own labels would build them.
      final labels = [0].map((_) {
        return ZplRectangleLabel(
          children: [ZplBarcode('\u{E9}', x: 0, y: 0)],
          width: 0,
          height: 0,
        );
      });

      await expectLater(
        printer.networkPrinter.printAll(labels),
        throwsArgumentError,
      );
      expect(await printer.hasBeenConnectedTo(), isFalse);
    });
  });

  group('[ZplNetworkPrinter.printAll] with a fake socket', () {
    Future<void> printAllWith(FakeSocket socket) {
      const label = ZplRectangleLabel(children: [], width: 0, height: 0);
      return IOOverrides.runZoned(
        () => buildNetworkPrinter().printAll([label]),
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          return Future.value(socket);
        },
      );
    }

    test(
      'closes but does not destroy the socket when nothing throws',
      () async {
        final socket = FakeSocket();

        await printAllWith(socket);

        expect(socket.isClosed, isTrue);
        expect(socket.isDestroyed, isFalse);
      },
    );

    for (final operation in SocketOperation.values) {
      test(
        'destroys the socket and rethrows when ${operation.name} throws',
        () async {
          final socket = FakeSocket(failingOperation: operation);

          await expectLater(printAllWith(socket), throwsA(same(socket.error)));
          expect(socket.isDestroyed, isTrue);
        },
      );
    }
  });

  group('[ZplNetworkPrinter.connectTimeout]', () {
    const customTimeout = Duration(milliseconds: 1234);

    Future<Duration?> captureTimeoutUsedBy(ZplNetworkPrinter networkPrinter) {
      Duration? connectTimeout;
      return IOOverrides.runZoned(
        () async {
          await networkPrinter.printAll([]);
          return connectTimeout;
        },
        socketConnect: (host, port, {sourceAddress, sourcePort = 0, timeout}) {
          connectTimeout = timeout;
          return Future.value(FakeSocket());
        },
      );
    }

    test('defaults to 10 seconds', () {
      expect(buildNetworkPrinter().connectTimeout, const Duration(seconds: 10));
    });

    test('defaults to 10 seconds through ZplPrinter.network', () {
      final networkPrinter = ZplPrinter.network(
        networkAddress: InternetAddress('0.0.0.0'),
        port: 9100,
      );

      expect(
        (networkPrinter as ZplNetworkPrinter).connectTimeout,
        const Duration(seconds: 10),
      );
    });

    test('is passed through ZplPrinter.network', () {
      final networkPrinter = ZplPrinter.network(
        networkAddress: InternetAddress('0.0.0.0'),
        port: 9100,
        connectTimeout: customTimeout,
      );

      expect(
        (networkPrinter as ZplNetworkPrinter).connectTimeout,
        customTimeout,
      );
    });

    test('is used to connect by default', () async {
      final timeout = await captureTimeoutUsedBy(buildNetworkPrinter());

      expect(timeout, const Duration(seconds: 10));
    });

    test('is used to connect when set', () async {
      final networkPrinter = ZplNetworkPrinter(
        networkAddress: InternetAddress('0.0.0.0'),
        port: 9100,
        connectTimeout: customTimeout,
      );

      final timeout = await captureTimeoutUsedBy(networkPrinter);

      expect(timeout, customTimeout);
    });

    test('distinguishes otherwise equal printers', () {
      final networkPrinter = ZplNetworkPrinter(
        networkAddress: InternetAddress('0.0.0.0'),
        port: 9100,
        connectTimeout: customTimeout,
      );

      expect(networkPrinter, isNot(buildNetworkPrinter()));
    });
  });
}
