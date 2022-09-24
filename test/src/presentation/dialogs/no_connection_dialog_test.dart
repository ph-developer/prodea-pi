import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/dialogs/no_connection_dialog.dart';

import '../../../test_helpers/finder.dart';

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
      await tester.pumpWidget(createWidgetUnderTest());

      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showNoConnectionDialog(context);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      final backButton = findWidgetByType<TextButton>(TextButton);

      expect(backButton.enabled, true);

      await tester.tap(find.byWidget(backButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
