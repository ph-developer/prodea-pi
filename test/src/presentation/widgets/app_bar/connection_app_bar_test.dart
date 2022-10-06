import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';
import 'package:prodea/src/presentation/controllers/navigation_controller.dart';
import 'package:prodea/src/presentation/dialogs/no_connection_dialog.dart';
import 'package:prodea/src/presentation/widgets/app_bar/connection_app_bar.dart';

import '../../../../mocks/mocks.dart';
import '../../../../mocks/widgets.dart';

void main() {
  late ConnectionStateController connectionStateControllerMock;
  late NavigationController navigationControllerMock;
  late Callable navigateBack;

  bool isConnected = false;

  setUp(() {
    connectionStateControllerMock = MockConnectionStateController();
    navigationControllerMock = MockNavigationController();

    navigateBack = MockCallable<void>();

    when(() => connectionStateControllerMock.isConnected)
        .thenAnswer((_) => isConnected);

    when(() => navigationControllerMock.navigateBack())
        .thenAnswer((_) => navigateBack);

    setupTestInjector((i) {
      i.unregister<ConnectionStateController>();
      i.unregister<NavigationController>();
      i.registerInstance<ConnectionStateController>(
          connectionStateControllerMock);
      i.registerInstance<NavigationController>(navigationControllerMock);
    });
  });

  testWidgets('deve testar a appBar de conexão (desconectado)', (tester) async {
    // arrange
    Finder widget;
    final onActionClick = MockCallable<void>();
    isConnected = false;
    await tester.pumpWidget(makeWidgetTestable(
      Scaffold(
        appBar: ConnectionAppBar(
          title: 'Titulo',
          actions: [
            IconButton(
              onPressed: onActionClick,
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    ));

    // assert
    expect(find.byType(ConnectionAppBar), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(2));
    expect(find.byIcon(Icons.abc), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    verifyNever(onActionClick);
    verifyNever(navigateBack);

    // aperta o botão de ação
    widget = find.byIcon(Icons.abc);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(onActionClick).called(1);

    // abre as informações de conexão
    widget = find.byIcon(Icons.wifi_off_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(NoConnectionDialog), findsOneWidget);
  });

  testWidgets('deve testar a appBar de conexão (conectado)', (tester) async {
    // arrange
    Finder widget;
    final onActionClick = MockCallable<void>();
    isConnected = true;
    await tester.pumpWidget(makeWidgetTestable(
      Scaffold(
        appBar: ConnectionAppBar(
          title: 'Titulo',
          actions: [
            IconButton(
              onPressed: onActionClick,
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    ));

    // assert
    expect(find.byType(ConnectionAppBar), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(1));
    expect(find.byIcon(Icons.abc), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
    verifyNever(onActionClick);
    verifyNever(navigateBack);

    // aperta o botão de ação
    widget = find.byIcon(Icons.abc);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(onActionClick).called(1);
  });
}
