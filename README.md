Send ZPL (Zebra Printing Language) commands to Zebra printers.

## Features

- 👷‍♂️ Create labels
- Send labels for print:
	- ✅ by network
	- 👷‍♂️ by USB
	- 👷‍♂️ by Bluetooth

## Getting Started

```dart
Future<void> createAndPrintZplLabel(
  InternetAddress printerAddress,
  int printerPort, // Usually 9100
) {
  // Get a printer (TODO: USB, Bluetooth printers)
  final ZplPrinter printer = ZplNetworkPrinter(
    networkAddress: printerAddress,
    port: printerPort,
  );

  // Make your label
  const label = ZplLabel(
    width: 300,
    height: 100,
    children: [
      ZplText(
        'Hello, adhesive label!',
        x: 50,
        y: 35,
        style: ZplTextStyle(fontSize: 18),
      ),
    ],
  );

  return printer.print(label);
}
```
