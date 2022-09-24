import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/services/asuka_notification_service.dart';

void main() {
  late AsukaNotificationService asukaNotificationService;

  setUp(() {
    asukaNotificationService = AsukaNotificationService();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      builder: Asuka.builder,
      home: const Scaffold(),
    );
  }

  group('notifySuccess', () {
    testWidgets(
      "deve mostrar uma snackbar contendo a mensagem de sucesso.",
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        asukaNotificationService.notifySuccess('sucesso');

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('sucesso'), findsOneWidget);
      },
    );
  });

  group('notifyError', () {
    testWidgets(
      "deve mostrar uma snackbar contendo a mensagem de erro.",
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        asukaNotificationService.notifyError('erro');

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('erro'), findsOneWidget);
      },
    );
  });
}
