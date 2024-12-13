import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpl2/zpl2.dart';

void main() {
  runApp(const MainApp());
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
                  final now = DateTime.now();
                  final date = '${now.month}/${now.day}/${now.year}';
                  final time = '${now.hour}:${now.minute}:${now.second}';

                  try {
                    final printer = ZplNetworkPrinter(
                      networkAddress: InternetAddress('10.0.0.13'),
                      port: 9100,
                    );
                    await printer.print(
                      ZplLabel(
                        children: [
                          ZplText(date, x: 50, y: 35),
                          ZplText(time, x: 50, y: 70),
                        ],
                        height: 50,
                        width: 150,
                      ),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
