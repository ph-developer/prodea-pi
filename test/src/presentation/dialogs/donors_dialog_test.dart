import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/presentation/dialogs/donors_dialog.dart';
import 'package:prodea/src/presentation/stores/users_store.dart';
import 'package:mobx/mobx.dart' as mobx;

import '../../../mocks/mocks.dart';

class TestModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.instance<UsersStore>(MockUsersStore()),
      ];
}

void main() {
  const tScaffoldKey = Key('scaffold');
  late UsersStore usersStoreMock;

  const tUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'Tester',
    address: 'Rua Teste',
    city: 'Cidade Teste/TESTE',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );

  setUp(() {
    usersStoreMock = MockUsersStore();

    when(() => usersStoreMock.donors)
        .thenReturn(mobx.ObservableList.of([tUser]));

    initModule(TestModule(), replaceBinds: [
      Bind.instance<UsersStore>(usersStoreMock),
    ]);
  });

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
      showDonorsDialog(context);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining(tUser.name), findsOneWidget);
      expect(find.textContaining(tUser.address), findsOneWidget);
      expect(find.textContaining(tUser.city), findsOneWidget);

      // voltar
      widget = find.byType(TextButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
