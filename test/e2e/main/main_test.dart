import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/router.dart';
import 'package:prodea/src/domain/services/network_service.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';
import 'package:prodea/src/presentation/pages/account/profile_page.dart';
import 'package:prodea/src/presentation/pages/admin/admin_page.dart';
import 'package:prodea/src/presentation/pages/main/available_donations_page.dart';
import 'package:prodea/src/presentation/pages/main/donate_page.dart';
import 'package:prodea/src/presentation/pages/main/my_donations_page.dart';
import 'package:prodea/src/presentation/pages/main/requested_donations_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';
import 'package:prodea/src/presentation/stores/users_store.dart';

import '../../mocks/e2e.dart';
import '../../mocks/mocks.dart';
import '../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuth firebaseAuthMock;
  late FirebaseFirestore firebaseFirestoreMock;
  late FirebaseStorage firebaseStorageMock;
  late ImagePicker imagePickerMock;
  late INetworkService networkServiceMock;

  setUp(() async {
    firebaseAuthMock = setupFirebaseAuthMock(true);
    firebaseFirestoreMock = await setupFirebaseFirestoreMock();
    firebaseStorageMock = await setupFirebaseStorageMock();
    imagePickerMock = await setupImagePickerMock();
    networkServiceMock = MockNetworkService();

    when(() => networkServiceMock.isConnected()).thenAnswer((_) async => true);

    setupTestInjector((i) {
      i.unregister<FirebaseAuth>();
      i.unregister<FirebaseStorage>();
      i.unregister<FirebaseFirestore>();
      i.unregister<ImagePicker>();
      i.unregister<INetworkService>();
      i.registerInstance<FirebaseAuth>(firebaseAuthMock);
      i.registerInstance<FirebaseStorage>(firebaseStorageMock);
      i.registerInstance<FirebaseFirestore>(firebaseFirestoreMock);
      i.registerInstance<ImagePicker>(imagePickerMock);
      i.registerInstance<INetworkService>(networkServiceMock);
    });

    final AuthController authController = inject();
    final ConnectionStateController connectionStateController = inject();
    final CitiesStore citiesStore = inject();
    final UsersStore usersStore = inject();

    await Future.wait([
      authController.fetchCurrentUser(),
      connectionStateController.fetchConnectionStatus(),
      citiesStore.fetchCities(),
      usersStore.fetchUsers(),
    ]);

    setupRouter();
  });

  testWidgets('deve testar a navegação entre páginas', (tester) async {
    // arrange
    Finder widget;
    binding.window.physicalSizeTestValue = const Size(576, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(makeApp());
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

    // navega para a página doações disponíveis
    widget = find.byIcon(Icons.local_mall_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(AvailableDonationsPage), findsOneWidget);

    // navega para a página doações solicitadas
    widget = find.byIcon(Icons.handshake_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(RequestedDonationsPage), findsOneWidget);

    // navega para a página doações solicitadas
    widget = find.byIcon(Icons.volunteer_activism_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(DonatePage), findsOneWidget);

    // navega para a página de informação do usuário
    widget = find.byIcon(Icons.person_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    // navega para a página de informação do usuário
    widget = find.byType(BackButton);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(MainPage), findsOneWidget);
    expect(find.byType(DonatePage), findsOneWidget);

    // navega para a página de administração
    widget = find.byIcon(Icons.admin_panel_settings_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(AdminPage), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    // navega para a página de informação do usuário
    widget = find.byType(BackButton);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(MainPage), findsOneWidget);
    expect(find.byType(DonatePage), findsOneWidget);

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });
}
