import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/presentation/dialogs/cancel_reason_dialog.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/widgets.dart';

void main() {
  const tScaffoldKey = Key('scaffold');

  testWidgets(
    'deve mostrar um diálogo, interagir com ele e retornar uma string na função onOk.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(makeDialogTestable(tScaffoldKey));
      final onOk = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showCancelReasonDialog(context, onOk: onOk);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));

      // escrever motivo
      widget = find.byType(TextFormField).at(0);
      await tester.enterText(widget, 'teste');
      await tester.pumpAndSettle();

      // confirmar
      widget = find.byType(TextButton).at(1);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onOk('teste')).called(1);
    },
  );

  testWidgets(
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(makeDialogTestable(tScaffoldKey));
      final onOk = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showCancelReasonDialog(context, onOk: onOk);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);

      // cancelar
      widget = find.byType(TextButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => onOk(any()));
    },
  );
}
