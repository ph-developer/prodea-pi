import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';
import 'package:prodea/src/presentation/controllers/navigation_controller.dart';
import 'package:prodea/src/presentation/widgets/app_bar/main_app_bar.dart';
import 'package:prodea/src/presentation/widgets/layout/breakpoint.dart';

import '../../../../mocks/mocks.dart';
import '../../../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  late ConnectionStateController connectionStateControllerMock;
  late NavigationController navigationControllerMock;
  late AuthController authControllerMock;
  late Callable onNavigate;

  bool isConnected = false;

  setUp(() {
    connectionStateControllerMock = MockConnectionStateController();
    navigationControllerMock = MockNavigationController();
    authControllerMock = MockAuthController();

    onNavigate = MockCallable<void>();

    when(() => connectionStateControllerMock.isConnected)
        .thenAnswer((_) => isConnected);

    when(() => navigationControllerMock.navigateToAdminPage())
        .thenAnswer((_) => onNavigate('admin'));
    when(() => navigationControllerMock.navigateToProfilePage())
        .thenAnswer((_) => onNavigate('profile'));
    when(() => navigationControllerMock.navigateToLoginPage())
        .thenAnswer((_) => onNavigate('login'));

    when(() => authControllerMock.isLoggedIn).thenAnswer((_) => true);
    when(() => authControllerMock.isAdmin).thenAnswer((_) => true);
    when(() => authControllerMock.currentUser).thenAnswer((_) => const User(
          id: 'id',
          email: 'email',
          cnpj: 'cnpj',
          name: 'Tester',
          address: 'address',
          city: 'city',
          phoneNumber: 'phoneNumber',
          about: 'about',
          responsibleName: 'responsibleName',
          responsibleCpf: 'responsibleCpf',
          isDonor: true,
          isBeneficiary: true,
          isAdmin: true,
          status: AuthorizationStatus.authorized,
        ));
    when(() => authControllerMock.logout(
          onSuccess: any(named: 'onSuccess'),
        )).thenAnswer((_) async => onNavigate('logout'));

    setupTestInjector((i) {
      i.unregister<ConnectionStateController>();
      i.unregister<NavigationController>();
      i.unregister<AuthController>();
      i.registerInstance<ConnectionStateController>(
          connectionStateControllerMock);
      i.registerInstance<NavigationController>(navigationControllerMock);
      i.registerInstance<AuthController>(authControllerMock);
    });
  });

  testWidgets('deve testar a appBar principal (mobile)', (tester) async {
    // arrange
    binding.window.physicalSizeTestValue = Size(
      Breakpoint.md.minDimension - 1,
      500,
    );
    binding.window.devicePixelRatioTestValue = 1.0;
    Finder widget;
    final onActionClick = MockCallable<void>();
    isConnected = true;
    await tester.pumpWidget(makeWidgetTestable(
      Scaffold(
        appBar: MainAppBar(
          icon: const Icon(Icons.ac_unit),
          title: 'Titulo',
          actions: [
            IconButton(
              onPressed: onActionClick,
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    ));

    // assert
    expect(find.byType(MainAppBar), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(3));
    expect(find.byIcon(Icons.abc), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsNothing);
    expect(find.text('Tester'), findsNothing);
    verifyNever(onActionClick);
    verifyNever(() => onNavigate(any()));

    // aperta o botão de ação
    widget = find.byIcon(Icons.abc);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(onActionClick).called(1);

    // aperta o botão navegar para a página administração
    widget = find.byIcon(Icons.admin_panel_settings_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(() => onNavigate('admin')).called(1);

    // aperta o botão navegar para a página perfil
    widget = find.byIcon(Icons.person_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(() => onNavigate('profile')).called(1);

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('deve testar a appBar principal (web)', (tester) async {
    // arrange
    binding.window.physicalSizeTestValue = Size(
      Breakpoint.md.minDimension * 1,
      500,
    );
    binding.window.devicePixelRatioTestValue = 1.0;
    Finder widget;
    final onActionClick = MockCallable<void>();
    isConnected = true;
    await tester.pumpWidget(makeWidgetTestable(
      Scaffold(
        appBar: MainAppBar(
          icon: const Icon(Icons.ac_unit),
          title: 'Titulo',
          actions: [
            IconButton(
              onPressed: onActionClick,
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    ));

    // assert
    expect(find.byType(MainAppBar), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.abc), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    expect(find.text('Tester'), findsOneWidget);
    verifyNever(onActionClick);
    verifyNever(() => onNavigate(any()));

    // aperta o botão de ação
    widget = find.byIcon(Icons.abc);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(onActionClick).called(1);

    // aperta o botão navegar para a página administração
    widget = find.byIcon(Icons.admin_panel_settings_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(() => onNavigate('admin')).called(1);

    // aperta o botão navegar para a página perfil
    widget = find.byIcon(Icons.person_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(() => onNavigate('profile')).called(1);

    // aperta o botão logout
    widget = find.byIcon(Icons.logout_rounded);
    await tester.tap(widget);
    await tester.pumpAndSettle();

    // assert
    verify(() => onNavigate('logout')).called(1);

    // tearDown
    addTearDown(binding.window.clearPhysicalSizeTestValue);
  });
}
