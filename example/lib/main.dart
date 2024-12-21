import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  runApp(const MainApp());
}

ZplLabel buildZplLabel() {
  final now = DateTime.now();
  final date = '${now.month}/${now.day}/${now.year}';
  final time = '${now.hour}:${now.minute}:${now.second}';

  return ZplLabel(
    children: [
      ZplText(date, x: 50, y: 35),
      ZplText(time, x: 50, y: 70),
      ZplBarcode(
        now.millisecondsSinceEpoch.toString(),
        x: 575,
        y: 50,
        alignment: ZplAlignment.right,
        barcodeFieldStyle: ZplBarcodeFieldDefault(
          barcodeHeight: 100,
        ),
      ),
    ],
    height: 200,
    width: 600,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Print current date and time'),
              const SizedBox(height: 16),
              FilledButton(
                child: const Text('Print'),
                onPressed: () async {
                  try {
                    final printer = ZplNetworkPrinter(
                      networkAddress: InternetAddress('10.0.0.13'),
                      port: 9100,
                    );
                    await printer.print(buildZplLabel());
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }

                  if (kDebugMode) {
                    print('Done!');
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Copy to Clipboard'),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: buildZplLabel().toZpl()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
