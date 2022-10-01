import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/dialogs/no_connection_dialog.dart';

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
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(createWidgetUnderTest());
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showNoConnectionDialog(context);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);

      // voltar
      widget = find.byType(TextButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
