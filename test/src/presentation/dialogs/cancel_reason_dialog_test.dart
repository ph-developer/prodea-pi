import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/presentation/dialogs/cancel_reason_dialog.dart';

import '../../../test_helpers/finder.dart';
import '../../../test_helpers/mobx.dart';

void main() {
  const tScaffoldKey = Key('scaffold');

  Widget createWidgetUnderTest() {
    return MaterialApp(
      builder: Asuka.builder,
      home: const Scaffold(
        key: tScaffoldKey,
      ),
    );
  }

  testWidgets(
    'deve mostrar um diálogo, interagir com ele e retornar uma string na função onOk.',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final onOk = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showCancelReasonDialog(context, onOk: onOk);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));

      final state = tester.state(find.byType(CancelReasonDialog)) as dynamic;
      final textFormField = findWidgetByType<TextFormField>(TextFormField);
      var submitButton = findWidgetByType<TextButton>(TextButton, 1);

      expect(textFormField.initialValue, isEmpty);
      expect(submitButton.enabled, false);

      await tester.tap(find.byWidget(submitButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      verifyNever(() => onOk(any()));

      await tester.enterText(find.byWidget(textFormField), 'teste');
      await tester.pump();

      submitButton = findWidgetByType<TextButton>(TextButton, 1);

      expect(state.value, 'teste');
      expect(submitButton.enabled, true);

      await tester.tap(find.byWidget(submitButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onOk('teste')).called(1);
    },
  );

  testWidgets(
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final onOk = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showCancelReasonDialog(context, onOk: onOk);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      final backButton = findWidgetByType<TextButton>(TextButton);

      expect(backButton.enabled, true);

      await tester.tap(find.byWidget(backButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => onOk(any()));
    },
  );
}
