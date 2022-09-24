import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/presentation/dialogs/user_info_dialog.dart';

import '../../../test_helpers/finder.dart';

void main() {
  const tScaffoldKey = Key('scaffold');
  const tUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'name',
    address: 'address',
    city: 'city',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );

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
      showUserDialog(context, user: tUser);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('CNPJ: ${tUser.cnpj}'), findsOneWidget);
      expect(find.text('Endereço: ${tUser.address}'), findsOneWidget);
      expect(find.text('Cidade: ${tUser.city}'), findsOneWidget);
      expect(find.text('Email: ${tUser.email}'), findsOneWidget);
      expect(find.text('Telefone: ${tUser.phoneNumber}'), findsOneWidget);
      expect(find.text('Nome do Responsável: ${tUser.responsibleName}'),
          findsOneWidget);
      expect(find.text('Sobre: ${tUser.about}'), findsOneWidget);

      final backButton = findWidgetByType<TextButton>(TextButton);

      expect(backButton.enabled, true);

      await tester.tap(find.byWidget(backButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
