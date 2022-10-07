import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/router.dart';
import 'package:prodea/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:prodea/src/presentation/pages/auth/login_page.dart';

import '../../mocks/e2e.dart';
import '../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuth firebaseAuthMock;
  late FirebaseFirestore firebaseFirestoreMock;
  late FirebaseStorage firebaseStorageMock;
  late ImagePicker imagePickerMock;

  setUp(() async {
    firebaseAuthMock = setupFirebaseAuthMock(false);
    firebaseFirestoreMock = await setupFirebaseFirestoreMock();
    firebaseStorageMock = await setupFirebaseStorageMock();
    imagePickerMock = await setupImagePickerMock();

    setupTestInjector((i) {
      i.unregister<FirebaseAuth>();
      i.unregister<FirebaseStorage>();
      i.unregister<FirebaseFirestore>();
      i.unregister<ImagePicker>();
      i.registerInstance<FirebaseAuth>(firebaseAuthMock);
      i.registerInstance<FirebaseStorage>(firebaseStorageMock);
      i.registerInstance<FirebaseFirestore>(firebaseFirestoreMock);
      i.registerInstance<ImagePicker>(imagePickerMock);
    });

    setupRouter();
  });

  testWidgets('deve testar a página recuperar senha', (tester) async {
    // arrange
    Finder widget;
    binding.window.physicalSizeTestValue = const Size(500, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(makeApp());
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

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });
}
