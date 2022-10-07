import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/router.dart';
import 'package:prodea/src/presentation/pages/web/home_page.dart';

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

  testWidgets('deve testar a página home (web)', (tester) async {
    // arrange
    binding.window.physicalSizeTestValue = const Size(1080, 1920);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(makeWidgetTestable(const HomePage()));
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(4));
    expect(find.text('Programa de Doação de Alimentos'), findsOneWidget);
    expect(find.text('Conheça a Lei'), findsOneWidget);
    expect(find.text('Conheça o Projeto'), findsOneWidget);
    expect(find.text('Participantes'), findsOneWidget);
    expect(find.text('Acessar Plataforma'), findsOneWidget);
    expect(find.text('Saiba mais'), findsNWidgets(3));

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });
}
