## 0.0.1

Add ZPL text and label.

## 0.1.1

Add ZPL network printer.

## 0.1.2

- Change ZPL printer to be sealed
- Add ZPL element equality

## 0.2.0

- Add barcode element

## 0.2.1

- Add field origin alignment

## 0.2.2

- Add label margins API

## 0.2.3

- Add `ZplPrinter.printAll`

## 0.2.4

- Add `ZplTextStyle.copyWith`

## 0.2.5

- Change `ZplLabel` to be sealed, with `ZplRectangleLabel` and
  `ZplBarbellLabel` implementations
- Add `ZplBarbellLabelMargins`
- Require Dart SDK 3.8.0

## 0.3.1

- Add `ZplBarbellLabelMargins.symmetric`

## 0.3.2

- Add `Code39Barcode`

## 0.3.3

- Add `ZplTextBlock`

## 0.3.4

- Print line breaks in `ZplText` as ZPL line breaks
- `ZplText` and `ZplTextBlock` are no longer `const`

## 1.0.0

- Upgrade the `custom_lint` dev dependency

## 1.0.1

- Upgrade `equatable` to 3.0.0

## 2.0.0

- **Breaking:** `ZplBarcode` is no longer `const`, and throws an
  `ArgumentError` for data its barcode type cannot encode
- **Breaking:** labels declare UTF-8 (`^CI28`), and field data is hex-escaped
  (`^FH`) so carets, tildes, and underscores print instead of running as
  commands
- Send labels as UTF-8 instead of truncating characters above U+00FF
- Build labels before connecting to the printer, and destroy the socket if
  sending fails
- Add `ZplNetworkPrinter.connectTimeout` (default 10 seconds)
