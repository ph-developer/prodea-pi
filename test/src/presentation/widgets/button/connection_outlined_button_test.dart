import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';
import 'package:prodea/src/presentation/widgets/button/connection_outlined_button.dart';

import '../../../../mocks/mocks.dart';
import '../../../../mocks/widgets.dart';

class TestModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.instance<ConnectionStateController>(
            MockConnectionStateController()),
      ];
}

void main() {
  late ConnectionStateController connectionStateControllerMock;

  bool isConnected = false;

  setUp(() {
    connectionStateControllerMock = MockConnectionStateController();

    when(() => connectionStateControllerMock.isConnected)
        .thenAnswer((_) => isConnected);

    initModule(TestModule(), replaceBinds: [
      Bind.instance<ConnectionStateController>(connectionStateControllerMock),
    ]);
  });

  testWidgets('deve testar o botão de conexão (desconectado)', (tester) async {
    // arrange
    Finder widget;
    isConnected = false;
    final onPressed = MockCallable<void>();
    await tester.pumpWidget(makeWidgetTestable(
      ConnectionOutlinedButton(
        onPressed: onPressed,
        child: const Text('Teste'),
      ),
    ));

    // assert
    expect(find.byType(ConnectionOutlinedButton), findsOneWidget);
    expect(find.text('Teste'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    widget = find.byType(OutlinedButton).at(0);
    expect(tester.widget<OutlinedButton>(widget).enabled, isFalse);

    // clica no botão
    await tester.tap(widget);

    // assert
    verifyNever(onPressed);
  });

  testWidgets('deve testar o botão de conexão (conectado)', (tester) async {
    // arrange
    Finder widget;
    isConnected = true;
    final onPressed = MockCallable<void>();
    await tester.pumpWidget(makeWidgetTestable(
      ConnectionOutlinedButton(
        onPressed: onPressed,
        child: const Text('Teste'),
      ),
    ));

    // assert
    expect(find.byType(ConnectionOutlinedButton), findsOneWidget);
    expect(find.text('Teste'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    widget = find.byType(OutlinedButton).at(0);
    expect(tester.widget<OutlinedButton>(widget).enabled, isTrue);

    // clica no botão
    await tester.tap(widget);

    // assert
    verify(onPressed).called(1);
  });
}
