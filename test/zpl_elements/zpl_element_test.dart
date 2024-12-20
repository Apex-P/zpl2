import 'package:flutter_test/flutter_test.dart';
import 'package:zpl2/zpl2.dart';

import '../zpl_commands/zpl_command_test.dart';

class MockZplDataElement extends ZplDataElement {
  const MockZplDataElement(this.numberOfCommands)
      : super(elementData: '<data>', x: 24, y: 50);

  /// Number of [MockZplCommand]s in [zplCommands].
  final int numberOfCommands;

  @override
  List<ZplCommand> get zplCommands => List.generate(
        numberOfCommands,
        (_) => const MockZplCommand(a: 1),
      );

  @override
  List<Object?> get props => super.props
    ..addAll([
      numberOfCommands,
    ]);
}

void main() {
  test('`ZplDataElement` core functionality', () {
    const expectedStart = '^FO24,50';
    const expectedEnd = '^FD<data>^FS';
    final expectedCommand = const MockZplCommand(a: 1).zpl;

    expect(
      const MockZplDataElement(0).toZpl(),
      '$expectedStart$expectedEnd',
    );
    expect(
      const MockZplDataElement(1).toZpl(),
      '$expectedStart$expectedCommand$expectedEnd',
    );
    expect(
      const MockZplDataElement(2).toZpl(),
      '$expectedStart$expectedCommand$expectedCommand$expectedEnd',
    );
  });
}
