import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/guards/auth_guard.dart';

import '../../../mocks/mocks.dart';

void main() {
  late AuthController authControllerMock;
  late AuthGuard guard;

  var isLoggedIn = true;

  setUp(() {
    authControllerMock = MockAuthController();
    guard = AuthGuard();

    when(() => authControllerMock.isLoggedIn).thenAnswer((_) => isLoggedIn);

    setupTestInjector((i) {
      i.unregister<AuthController>();
      i.registerInstance<AuthController>(authControllerMock);
    });
  });

  group('redirectTo', () {
    test(
      'deve retornar a rota login.',
      () {
        // act
        final result = guard.redirectTo;
        // assert
        expect(result, '/login');
      },
    );
  });

  group('canActivate', () {
    test(
      'deve retornar true se o usuário estiver logado.',
      () async {
        // arrange
        isLoggedIn = true;
        // act
        final result = await guard.canActivate('/', ParallelRoute(name: '/'));
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se o usuário não estiver logado.',
      () async {
        // arrange
        isLoggedIn = false;
        // act
        final result = await guard.canActivate('/', ParallelRoute(name: '/'));
        // assert
        expect(result, false);
      },
    );
  });
}
