import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/router.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/auth/register_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

import '../../mocks/e2e.dart';
import '../../mocks/mocks.dart';
import '../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuth firebaseAuthMock;
  late FirebaseFirestore firebaseFirestoreMock;
  late FirebaseStorage firebaseStorageMock;
  late ImagePicker imagePickerMock;
  late CitiesStore citiesStoreMock;

  setUp(() async {
    firebaseAuthMock = setupFirebaseAuthMock(false);
    firebaseFirestoreMock = await setupFirebaseFirestoreMock();
    firebaseStorageMock = await setupFirebaseStorageMock();
    imagePickerMock = await setupImagePickerMock();
    citiesStoreMock = MockCitiesStore();

    when(() => citiesStoreMock.cities).thenAnswer(
        (_) => mobx.ObservableList.of(['Araçatuba/SP', 'Penápolis/SP']));

    setupTestInjector((i) {
      i.unregister<FirebaseAuth>();
      i.unregister<FirebaseStorage>();
      i.unregister<FirebaseFirestore>();
      i.unregister<ImagePicker>();
      i.unregister<CitiesStore>();
      i.registerInstance<FirebaseAuth>(firebaseAuthMock);
      i.registerInstance<FirebaseStorage>(firebaseStorageMock);
      i.registerInstance<FirebaseFirestore>(firebaseFirestoreMock);
      i.registerInstance<ImagePicker>(imagePickerMock);
      i.registerInstance<CitiesStore>(citiesStoreMock);
    });

    setupRouter();
  });

  testWidgets('deve testar a página de cadastro', (tester) async {
    // arrange
    Finder widget;
    binding.window.physicalSizeTestValue = const Size(500, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(LoginPage), findsOneWidget);

    // navegar para a página de cadastro
    widget = find.byType(OutlinedButton).at(2);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(10));
    expect(find.byType(Checkbox), findsNWidgets(2));
    expect(find.byType(OutlinedButton), findsNWidgets(2));

    // escrever email
    widget = find.byType(TextFormField).at(0);
    await tester.enterText(widget, 'test@test.dev');
    await tester.pumpAndSettle();

    // escrever senha
    widget = find.byType(TextFormField).at(1);
    await tester.enterText(widget, 'senha');
    await tester.pumpAndSettle();

    // escrever cnpj
    widget = find.byType(TextFormField).at(2);
    await tester.enterText(widget, '00.000.000/0000-00');
    await tester.pumpAndSettle();

    // escrever nome
    widget = find.byType(TextFormField).at(3);
    await tester.enterText(widget, 'nome');
    await tester.pumpAndSettle();

    // escrever endereço
    widget = find.byType(TextFormField).at(4);
    await tester.enterText(widget, 'endereço');
    await tester.pumpAndSettle();

    // abrir modal para selecionar cidade
    widget = find.byType(TextFormField).at(5);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(CitySelectDialog), findsOneWidget);

    // filtrar cidades
    widget = find.byIcon(Icons.filter_alt_rounded);
    widget =
        find.ancestor(of: widget, matching: find.byType(TextFormField)).at(0);
    await tester.enterText(widget, 'penap');
    await tester.pumpAndSettle();

    // assert
    expect(find.text('Penápolis/SP'), findsOneWidget);

    // selecionar cidade
    widget = find.text('Penápolis/SP');
    widget = find.ancestor(of: widget, matching: find.byType(ListTile)).at(0);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(CitySelectDialog), findsNothing);

    // escrever telefone
    widget = find.byType(TextFormField).at(6);
    await tester.enterText(widget, '(00) 00000-0000');
    await tester.pumpAndSettle();

    // escrever sobre
    widget = find.byType(TextFormField).at(7);
    await tester.enterText(widget, 'sobre');
    await tester.pumpAndSettle();

    // escrever nome do responsável
    widget = find.byType(TextFormField).at(8);
    await tester.enterText(widget, 'nome do responsável');
    await tester.pumpAndSettle();

    // escrever cpf do responsável
    widget = find.byType(TextFormField).at(9);
    await tester.enterText(widget, '000.000.000-00');
    await tester.pumpAndSettle();

    // descer scroll até visualizar o botão voltar
    widget = find.byType(SingleChildScrollView).at(0);
    widget =
        find.descendant(of: widget, matching: find.byType(Scrollable)).at(0);
    await tester.scrollUntilVisible(
      find.byType(OutlinedButton).at(1),
      500.0,
      scrollable: widget,
    );
    await tester.pumpAndSettle();

    // marcar checkbox de doador
    widget = find.byType(Checkbox).at(0);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // marcar checkbox de beneficiário
    widget = find.byType(Checkbox).at(1);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // efetuar cadastro
    widget = find.byType(OutlinedButton).at(0);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(MainPage), findsOneWidget);

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });
}
