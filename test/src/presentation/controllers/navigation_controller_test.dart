import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:prodea/src/domain/usecases/navigation/get_current_route.dart';
import 'package:prodea/src/domain/usecases/navigation/go_back.dart';
import 'package:prodea/src/domain/usecases/navigation/go_to.dart';
import 'package:prodea/src/presentation/controllers/navigation_controller.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GoTo goToMock;
  late GoBack goBackMock;
  late GetCurrentRoute getCurrentRouteMock;
  late NavigationController controller;

  setUp(() {
    goToMock = MockGoTo();
    goBackMock = MockGoBack();
    getCurrentRouteMock = MockGetCurrentRoute();
    controller = NavigationController(
      getCurrentRouteMock,
      goToMock,
      goBackMock,
    );
  });

  group('fetchCurrentRoute', () {
    test(
      'deve inicializar o controller, e setar o caminho da página atual.',
      () async {
        // arrange
        when(getCurrentRouteMock)
            .thenAnswer((_) => Stream.fromIterable(['/login']));
        final isCurrentRouteChanged = MockCallable<String>();
        whenReaction((_) => controller.currentRoute, isCurrentRouteChanged);
        // act
        controller.fetchCurrentRoute();
        await untilCalled(() => isCurrentRouteChanged('/login'));
        // assert
        expect(controller.currentRoute, '/login');
      },
    );
  });

  group('navigateBack', () {
    test(
      'deve navegar para a rota anterior.',
      () {
        // act
        controller.navigateBack();
        // assert
        verify(goBackMock).called(1);
      },
    );
  });

  group('navigateBack', () {
    test(
      'deve navegar para a rota anterior.',
      () {
        // act
        controller.navigateBack();
        // assert
        verify(goBackMock).called(1);
      },
    );
  });

  group('navigateToLoginPage', () {
    test(
      'deve navegar para a rota de login, usando o modo replace.',
      () {
        // act
        controller.navigateToLoginPage();
        // assert
        verify(() => goToMock('/login', replace: true)).called(1);
        verifyNever(() => goToMock(any(), replace: false));
      },
    );
  });

  group('navigateToForgotPasswordPage', () {
    test(
      'deve navegar para a rota de recuperação de senha, usando o modo replace.',
      () {
        // act
        controller.navigateToForgotPasswordPage();
        // assert
        verify(() => goToMock('/forgot', replace: true)).called(1);
        verifyNever(() => goToMock(any(), replace: false));
      },
    );
  });

  group('navigateToRegisterPage', () {
    test(
      'deve navegar para a rota de cadastro, usando o modo replace.',
      () {
        // act
        controller.navigateToRegisterPage();
        // assert
        verify(() => goToMock('/register', replace: true)).called(1);
        verifyNever(() => goToMock(any(), replace: false));
      },
    );
  });

  group('navigateToMainPage', () {
    test(
      'deve navegar para a rota principal, usando o modo replace.',
      () {
        // act
        controller.navigateToMainPage();
        // assert
        verify(() => goToMock('/main', replace: true)).called(1);
        verifyNever(() => goToMock(any(), replace: false));
      },
    );
  });

  group('navigateToAdminPage', () {
    test(
      'deve navegar para a rota admin, sem usar o modo replace.',
      () {
        // act
        controller.navigateToAdminPage();
        // assert
        verify(() => goToMock('/admin', replace: false)).called(1);
        verifyNever(() => goToMock(any(), replace: true));
      },
    );
  });

  group('navigateToProfilePage', () {
    test(
      'deve navegar para a rota perfil, sem usar o modo replace.',
      () {
        // act
        controller.navigateToProfilePage();
        // assert
        verify(() => goToMock('/profile', replace: false)).called(1);
        verifyNever(() => goToMock(any(), replace: true));
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = controller.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
