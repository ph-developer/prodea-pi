import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/injector.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';
import 'package:prodea/src/presentation/guards/guest_guard.dart';

import '../../../mocks/mocks.dart';

void main() {
  late AuthController authControllerMock;
  late GuestGuard guard;

  var isLoggedIn = true;

  setUp(() {
    authControllerMock = MockAuthController();
    guard = GuestGuard();

    when(() => authControllerMock.isLoggedIn).thenAnswer((_) => isLoggedIn);

    setupTestInjector((i) {
      i.unregister<AuthController>();
      i.registerInstance<AuthController>(authControllerMock);
    });
  });

  group('redirectTo', () {
    test(
      'deve retornar a rota main.',
      () {
        // act
        final result = guard.redirectTo;
        // assert
        expect(result, '/main');
      },
    );
  });

  group('canActivate', () {
    test(
      'deve retornar true se o usuário não estiver logado.',
      () async {
        // arrange
        isLoggedIn = false;
        // act
        final result = await guard.canActivate('/', ParallelRoute(name: '/'));
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se o usuário estiver logado.',
      () async {
        // arrange
        isLoggedIn = true;
        // act
        final result = await guard.canActivate('/', ParallelRoute(name: '/'));
        // assert
        expect(result, false);
      },
    );
  });
}
