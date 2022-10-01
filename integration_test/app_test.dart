import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/firebase_options.dart';
import 'package:prodea/main.dart' as app;
import 'package:prodea/src/app_module.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/auth/register_page.dart';
import 'package:prodea/src/presentation/pages/main/donate_page.dart';
import 'package:prodea/src/presentation/pages/main/my_donations_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';

import 'test_helpers/finder.dart';
import 'test_helpers/firebase_mocks.dart';
import 'test_helpers/image_picker_mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppModule appModule;
  late FirebaseAuth firebaseAuthMock;
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
        firebaseAuthMock = setupFirebaseAuthMock(false);
        appModule = AppModule();

        initModule(appModule, replaceBinds: [
          Bind.instance<FirebaseAuth>(firebaseAuthMock),
          Bind.instance<FirebaseStorage>(firebaseStorageMock),
          Bind.instance<FirebaseFirestore>(firebaseFirestoreMock),
          Bind.instance<ImagePicker>(imagePickerMock),
        ]);
      });

      testWidgets(
        'deve testar a página de login',
        (tester) async {
          await tester.runAsync(() => app.main([], appModule));
          await tester.pumpAndSettle();

          expect(find.byType(LoginPage), findsOneWidget);
          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(OutlinedButton), findsNWidgets(3));

          final emailFormField = findWidgetByType<TextFormField>(TextFormField);
          await tester.enterText(
              find.byWidget(emailFormField), 'test@test.dev');

          var passwordFormField =
              findWidgetByType<TextFormField>(TextFormField, 1);
          await tester.enterText(find.byWidget(passwordFormField), '1');

          var submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
          await tester.tap(find.byWidget(submitButton));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);

          passwordFormField = findWidgetByType<TextFormField>(TextFormField, 1);
          await tester.tap(find.byWidget(passwordFormField));
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

          var forgotButton =
              findWidgetByType<OutlinedButton>(OutlinedButton, 1);
          await tester.tap(find.byWidget(forgotButton));
          await tester.pumpAndSettle();

          expect(find.byType(ForgotPasswordPage), findsOneWidget);
          expect(find.byType(TextFormField), findsNWidgets(1));
          expect(find.byType(OutlinedButton), findsNWidgets(2));

          final emailFormField = findWidgetByType<TextFormField>(TextFormField);
          await tester.enterText(
              find.byWidget(emailFormField), 'test@test.dev');

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

          var forgotButton =
              findWidgetByType<OutlinedButton>(OutlinedButton, 2);
          await tester.tap(find.byWidget(forgotButton));
          await tester.pumpAndSettle();

          expect(find.byType(RegisterPage), findsOneWidget);
          expect(find.byType(TextFormField), findsNWidgets(10));
          expect(find.byType(Checkbox), findsNWidgets(2));
          expect(find.byType(OutlinedButton), findsNWidgets(2));

          final emailFormField = findWidgetByType<TextFormField>(TextFormField);
          await tester.enterText(
              find.byWidget(emailFormField), 'test@test.dev');

          final passwordFormField =
              findWidgetByType<TextFormField>(TextFormField, 1);
          await tester.enterText(find.byWidget(passwordFormField), 'test');

          final cnpjFormField =
              findWidgetByType<TextFormField>(TextFormField, 2);
          await tester.enterText(
              find.byWidget(cnpjFormField), '00.000.000/0000-00');

          final nameFormField =
              findWidgetByType<TextFormField>(TextFormField, 3);
          await tester.enterText(find.byWidget(nameFormField), 'test');

          final addressFormField =
              findWidgetByType<TextFormField>(TextFormField, 4);
          await tester.enterText(find.byWidget(addressFormField), 'test');

          final cityFormField =
              findWidgetByType<TextFormField>(TextFormField, 5);
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
          await tester.enterText(
              find.byWidget(responsibleNameFormField), 'test');

          final responsibleCpfFormField =
              findWidgetByType<TextFormField>(TextFormField, 9);
          await tester.enterText(
              find.byWidget(responsibleCpfFormField), '000.000.000-00');

          await tester.tapAt(const Offset(0, 0));
          await tester.pumpAndSettle();

          final donorCheckbox = findWidgetByType<Checkbox>(Checkbox);
          await tester.tap(find.byWidget(donorCheckbox));
          await tester.pumpAndSettle();

          final beneficiaryCheckbox = findWidgetByType<Checkbox>(Checkbox, 1);
          await tester.tap(find.byWidget(beneficiaryCheckbox));
          await tester.pumpAndSettle();

          final submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
          await tester.tap(find.byWidget(submitButton));
          await tester.pumpAndSettle();

          expect(find.byType(MainPage), findsOneWidget);
        },
      );
    });

    group('Testes de Plataforma', () {
      setUp(() {
        firebaseAuthMock = setupFirebaseAuthMock(true);
        appModule = AppModule();

        initModule(appModule, replaceBinds: [
          Bind.instance<FirebaseAuth>(firebaseAuthMock),
          Bind.instance<FirebaseStorage>(firebaseStorageMock),
          Bind.instance<FirebaseFirestore>(firebaseFirestoreMock),
          Bind.instance<ImagePicker>(imagePickerMock),
        ]);
      });

      testWidgets(
        'deve testar a página doar',
        (tester) async {
          await tester.runAsync(() => app.main([], appModule));
          await tester.pumpAndSettle();

          expect(find.byType(MainPage), findsOneWidget);
          expect(find.byType(DonatePage), findsOneWidget);
          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(OutlinedButton), findsNWidgets(3));

          final descriptionFormField =
              findWidgetByType<TextFormField>(TextFormField);
          await tester.enterText(
              find.byWidget(descriptionFormField), 'description');

          await tester.tapAt(const Offset(0, 0));
          await tester.pumpAndSettle();

          var takePhotoButton =
              findWidgetByType<OutlinedButton>(OutlinedButton);
          await tester.tap(find.byWidget(takePhotoButton));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.close_rounded), findsOneWidget);

          var clearPhotoButton = findWidgetByIcon<Icon>(Icons.close_rounded);
          await tester.tap(find.byWidget(clearPhotoButton));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.close_rounded), findsNothing);

          takePhotoButton = findWidgetByType<OutlinedButton>(OutlinedButton, 1);
          await tester.tap(find.byWidget(takePhotoButton));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.close_rounded), findsOneWidget);

          clearPhotoButton = findWidgetByIcon<Icon>(Icons.close_rounded);
          await tester.tap(find.byWidget(clearPhotoButton));
          await tester.pumpAndSettle();

          var dropdown = findWidgetByType<DropdownButtonFormField<String?>>(
              DropdownButtonFormField<String?>);
          await tester.tap(find.byWidget(dropdown));
          await tester.pumpAndSettle();

          await tester.tap(find.text('anon').at(1));
          await tester.pumpAndSettle();

          var expirationFormField =
              findWidgetByType<TextFormField>(TextFormField, 1);
          await tester.enterText(
              find.byWidget(expirationFormField), '01/12/5000');

          await tester.tapAt(const Offset(0, 0));
          await tester.pumpAndSettle();

          var submitButton =
              findWidgetByType<OutlinedButton>(OutlinedButton, 2);
          await tester.tap(find.byWidget(submitButton));
          await tester.pumpAndSettle();

          expect(find.byType(MainPage), findsOneWidget);
          expect(find.byType(MyDonationsPage), findsOneWidget);
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('description'), findsOneWidget);
          expect(find.textContaining('anon'), findsOneWidget);
        },
      );
    });
  });
}
