import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/guards/auth_guard.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GoRouterState goRouterStateMock;
  late AuthController authControllerMock;

  var isLoggedIn = true;

  setUp(() {
    goRouterStateMock = MockGoRouterState();
    authControllerMock = MockAuthController();

    when(() => authControllerMock.isLoggedIn).thenAnswer((_) => isLoggedIn);

    setupTestInjector((i) {
      i.unregister<AuthController>();
      i.registerInstance<AuthController>(authControllerMock);
    });
  });

  test(
    'deve retornar null se o usuário estiver logado.',
    () async {
      // arrange
      isLoggedIn = true;
      // act
      final result = await authGuard(MockBuildContext(), goRouterStateMock);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'deve retornar /login se o usuário não estiver logado.',
    () async {
      // arrange
      isLoggedIn = false;
      // act
      final result = await authGuard(MockBuildContext(), goRouterStateMock);
      // assert
      expect(result, equals('/login'));
    },
  );
}
