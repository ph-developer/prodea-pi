import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/firebase_options.dart';
import 'package:prodea/main.dart' as app;
import 'package:prodea/src/app_module.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/auth/register_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';

import '../test/test_helpers/finder.dart';
import 'test_helpers/firebase_mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppModule appModule;
  late FirebaseAuth firebaseAuthMock;
  late FirebaseFirestore firebaseFirestoreMock;
  late FirebaseStorage firebaseStorageMock;

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseAuthMock = setupFirebaseAuthMock();
    firebaseFirestoreMock = await setupFirebaseFirestoreMock();
    firebaseStorageMock = await setupFirebaseStorageMock();

    appModule = AppModule();
    initModule(appModule, replaceBinds: [
      Bind.instance<FirebaseAuth>(firebaseAuthMock),
      Bind.instance<FirebaseStorage>(firebaseStorageMock),
      Bind.instance<FirebaseFirestore>(firebaseFirestoreMock),
    ]);
  });

  group('Testes E2E', () {
    testWidgets(
      'deve testar a página de login',
      (tester) async {
        await tester.runAsync(() => app.main([], appModule));
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(OutlinedButton), findsNWidgets(3));

        final emailFormField = findWidgetByType<TextFormField>(TextFormField);
        await tester.enterText(find.byWidget(emailFormField), 'test@test.dev');

        var passwordFormField =
            findWidgetByType<TextFormField>(TextFormField, 1);
        await tester.enterText(find.byWidget(passwordFormField), '1');

        var submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
        await tester.tap(find.byWidget(submitButton));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);

        passwordFormField = findWidgetByType<TextFormField>(TextFormField, 1);
        await tester.enterText(find.byWidget(passwordFormField), '123');

        submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
        await tester.tap(find.byWidget(submitButton));
        await tester.pumpAndSettle();

        expect(find.byType(MainPage), findsOneWidget);
      },
    );

    testWidgets(
      'deve testar a página de recuperação de senha',
      (tester) async {
        await tester.runAsync(() => app.main([], appModule));
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);

        var forgotButton = findWidgetByType<OutlinedButton>(OutlinedButton, 1);
        await tester.tap(find.byWidget(forgotButton));
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(1));
        expect(find.byType(OutlinedButton), findsNWidgets(2));

        final emailFormField = findWidgetByType<TextFormField>(TextFormField);
        await tester.enterText(find.byWidget(emailFormField), 'test@test.dev');

        final submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
        await tester.tap(find.byWidget(submitButton));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      'deve testar a página de cadastro',
      (tester) async {
        await tester.runAsync(() => app.main([], appModule));
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);

        var forgotButton = findWidgetByType<OutlinedButton>(OutlinedButton, 2);
        await tester.tap(find.byWidget(forgotButton));
        await tester.pumpAndSettle();

        expect(find.byType(RegisterPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(10));
        expect(find.byType(Checkbox), findsNWidgets(2));
        expect(find.byType(OutlinedButton), findsNWidgets(2));

        final emailFormField = findWidgetByType<TextFormField>(TextFormField);
        await tester.enterText(find.byWidget(emailFormField), 'test@test.dev');

        final passwordFormField =
            findWidgetByType<TextFormField>(TextFormField, 1);
        await tester.enterText(find.byWidget(passwordFormField), 'test');

        final cnpjFormField = findWidgetByType<TextFormField>(TextFormField, 2);
        await tester.enterText(
            find.byWidget(cnpjFormField), '00.000.000/0000-00');

        final nameFormField = findWidgetByType<TextFormField>(TextFormField, 3);
        await tester.enterText(find.byWidget(nameFormField), 'test');

        final addressFormField =
            findWidgetByType<TextFormField>(TextFormField, 4);
        await tester.enterText(find.byWidget(addressFormField), 'test');

        final cityFormField = findWidgetByType<TextFormField>(TextFormField, 5);
        await tester.tap(find.byWidget(cityFormField));
        await tester.pumpAndSettle();

        expect(find.byType(CitySelectDialog), findsOneWidget);

        final filterIcon = findWidgetByIcon<Icon>(Icons.filter_alt_rounded);
        final filterFormField = find
            .ancestor(
              of: find.byWidget(filterIcon),
              matching: find.byType(TextFormField),
            )
            .evaluate()
            .first
            .widget as TextFormField;
        await tester.enterText(find.byWidget(filterFormField), 'penap');
        await tester.pumpAndSettle();

        expect(find.text('Penápolis/SP'), findsOneWidget);

        final penapolisText = findWidgetByText<Text>('Penápolis/SP');
        final penapolisListTile = find
            .ancestor(
              of: find.byWidget(penapolisText),
              matching: find.byType(ListTile),
            )
            .evaluate()
            .first
            .widget as ListTile;
        await tester.tap(find.byWidget(penapolisListTile));
        await tester.pumpAndSettle();

        expect(find.byType(CitySelectDialog), findsNothing);

        final phoneFormField =
            findWidgetByType<TextFormField>(TextFormField, 6);
        await tester.enterText(
            find.byWidget(phoneFormField), '(00) 00000-0000');

        final aboutFormField =
            findWidgetByType<TextFormField>(TextFormField, 7);
        await tester.enterText(find.byWidget(aboutFormField), 'test');

        final responsibleNameFormField =
            findWidgetByType<TextFormField>(TextFormField, 8);
        await tester.enterText(find.byWidget(responsibleNameFormField), 'test');

        final responsibleCpfFormField =
            findWidgetByType<TextFormField>(TextFormField, 9);
        await tester.enterText(
            find.byWidget(responsibleCpfFormField), '000.000.000-00');

        final donorCheckbox = findWidgetByType<Checkbox>(Checkbox);
        await tester.tap(find.byWidget(donorCheckbox));
        await tester.pumpAndSettle();

        final beneficiaryCheckbox = findWidgetByType<Checkbox>(Checkbox, 1);
        await tester.tap(find.byWidget(beneficiaryCheckbox));
        await tester.pumpAndSettle();

        await tester.pump(const Duration(seconds: 1));

        final submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
        await tester.tap(find.byWidget(submitButton));
        await tester.pumpAndSettle();

        expect(find.byType(MainPage), findsOneWidget);
      },
    );
  });
}
