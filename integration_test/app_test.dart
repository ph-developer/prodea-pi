import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prodea/firebase_options.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/main.dart' as app;
import 'package:prodea/src/presentation/dialogs/cancel_reason_dialog.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/auth/register_page.dart';
import 'package:prodea/src/presentation/pages/main/donate_page.dart';
import 'package:prodea/src/presentation/pages/main/my_donations_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';

import 'mocks/mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseFirestore firebaseFirestoreMock;
  late FirebaseStorage firebaseStorageMock;
  late ImagePicker imagePickerMock;

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  setUp(() async {
    firebaseFirestoreMock = await setupFirebaseFirestoreMock();
    firebaseStorageMock = await setupFirebaseStorageMock();
    imagePickerMock = await setupImagePickerMock();
  });

  group('Testes E2E', () {
    group('Testes de Autenticação', () {
      setUp(() {
        setupTestInjector((i) {
          i.unregister<FirebaseStorage>();
          i.unregister<FirebaseFirestore>();
          i.unregister<ImagePicker>();
          i.unregister<FirebaseAuth>();
          i.registerInstance<FirebaseStorage>(firebaseStorageMock);
          i.registerInstance<FirebaseFirestore>(firebaseFirestoreMock);
          i.registerInstance<ImagePicker>(imagePickerMock);
          i.registerFactory<FirebaseAuth>((_) => setupFirebaseAuthMock(false));
        });
      });

      testWidgets('deve testar a página de login', (tester) async {
        // arrange
        Finder widget;
        await tester.runAsync(() => app.main());
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(OutlinedButton), findsNWidgets(3));

        // escrever email
        widget = find.byType(TextFormField).at(0);
        await tester.enterText(widget, 'test@test.dev');
        await tester.pumpAndSettle();

        // escrever senha incorreta
        widget = find.byType(TextFormField).at(1);
        await tester.enterText(widget, '1');
        await tester.pumpAndSettle();

        // tentar efetuar login
        widget = find.byType(OutlinedButton).at(0);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(SnackBar), findsOneWidget);

        // escrever senha correta
        widget = find.byType(TextFormField).at(1);
        await tester.enterText(widget, '123');
        await tester.pumpAndSettle();

        // efetuar login
        widget = find.byType(OutlinedButton).at(0);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MainPage), findsOneWidget);
      });

      testWidgets('deve testar a página recuperar senha', (tester) async {
        // arrange
        Finder widget;
        await tester.runAsync(() => app.main());
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(LoginPage), findsOneWidget);

        // navegar para a página recuperar senha
        widget = find.byType(OutlinedButton).at(1);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(ForgotPasswordPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(1));
        expect(find.byType(OutlinedButton), findsNWidgets(2));

        // escrever email
        widget = find.byType(TextFormField).at(0);
        await tester.enterText(widget, 'test@test.dev');
        await tester.pumpAndSettle();

        /// efetuar recuperação de senha
        widget = find.byType(OutlinedButton).at(0);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.byType(LoginPage), findsOneWidget);
      });

      testWidgets('deve testar a página de cadastro', (tester) async {
        // arrange
        Finder widget;
        await tester.runAsync(() => app.main());
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
        widget = find
            .ancestor(of: widget, matching: find.byType(TextFormField))
            .at(0);
        await tester.enterText(widget, 'penap');
        await tester.pumpAndSettle();

        // assert
        expect(find.text('Penápolis/SP'), findsOneWidget);

        // selecionar cidade
        widget = find.text('Penápolis/SP');
        widget =
            find.ancestor(of: widget, matching: find.byType(ListTile)).at(0);
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
        widget = find
            .descendant(of: widget, matching: find.byType(Scrollable))
            .at(0);
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
      });
    });

    group('Testes de Plataforma', () {
      setUp(() {
        setupTestInjector((i) {
          i.unregister<FirebaseStorage>();
          i.unregister<FirebaseFirestore>();
          i.unregister<ImagePicker>();
          i.unregister<FirebaseAuth>();
          i.registerInstance<FirebaseStorage>(firebaseStorageMock);
          i.registerInstance<FirebaseFirestore>(firebaseFirestoreMock);
          i.registerInstance<ImagePicker>(imagePickerMock);
          i.registerFactory<FirebaseAuth>((_) => setupFirebaseAuthMock(true));
        });
      });

      testWidgets('deve testar a página doar', (tester) async {
        // arrange
        Finder widget;
        await tester.runAsync(() => app.main());
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(DonatePage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(OutlinedButton), findsNWidgets(3));

        // escrever descrição
        widget = find.byType(TextFormField).at(0);
        await tester.enterText(widget, 'descrição');
        await tester.pumpAndSettle();

        // tirar foto
        widget = find.byType(OutlinedButton).at(0);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);

        // remover foto
        widget = find.byIcon(Icons.close_rounded);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byIcon(Icons.close_rounded), findsNothing);

        // escolher foto da galeria
        widget = find.byType(OutlinedButton).at(1);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);

        // remover foto
        widget = find.byIcon(Icons.close_rounded);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // abrir dropdown para selecionar beneficiário
        widget = find.byType(DropdownButtonFormField<String?>);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // selecionar beneficiário
        widget = find.text('anon').at(1);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // escrever vencimento
        widget = find.byType(TextFormField).at(1);
        await tester.enterText(widget, '01/12/2022');
        await tester.pumpAndSettle();

        // postar doação
        widget = find.byType(OutlinedButton).at(2);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(MyDonationsPage), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.byType(Card), findsNWidgets(3));
        expect(find.text('descrição'), findsOneWidget);
        expect(find.textContaining('anon'), findsNWidgets(2));
      });

      testWidgets('deve testar a página minhas doações', (tester) async {
        // arrange
        Finder widget;
        await tester.runAsync(() => app.main());
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(DonatePage), findsOneWidget);

        // navega para a página minhas doações
        widget = find.byIcon(Icons.thumb_up_alt_rounded);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MyDonationsPage), findsOneWidget);
        expect(find.byType(Card), findsNWidgets(2));
        expect(find.text('Marcar como Entregue'), findsOneWidget);
        expect(find.text('Cancelar Doação'), findsNWidgets(2));

        // marcar doação como entregue
        widget = find.text('Marcar como Entregue');
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(Card), findsNWidgets(2));
        expect(find.text('Marcar como Entregue'), findsNothing);
        expect(find.text('Cancelar Doação'), findsOneWidget);

        // cancelar doação
        widget = find.text('Cancelar Doação');
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(Card), findsNWidgets(2));
        expect(find.byType(CancelReasonDialog), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Voltar'), findsOneWidget);
        expect(find.text('Cancelar Doação'), findsNWidgets(3));

        // escrever motivo da doação
        widget = find.byType(TextFormField);
        await tester.enterText(widget, 'Teste');
        await tester.pumpAndSettle();

        // cancelar doação
        widget = find.text('Cancelar Doação').at(2);
        await tester.tap(widget);
        await tester.pumpAndSettle();

        // assert
        expect(find.byType(MyDonationsPage), findsOneWidget);
        expect(find.byType(Card), findsNWidgets(2));
        expect(find.byType(CancelReasonDialog), findsNothing);
        expect(find.byType(TextFormField), findsNothing);
        expect(find.textContaining('Motivo: Teste'), findsOneWidget);
        expect(find.text('Voltar'), findsNothing);
        expect(find.text('Cancelar Doação'), findsNothing);
      });
    });
  });
}
