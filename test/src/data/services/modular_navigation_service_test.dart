import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/data/services/modular_navigation_service.dart';

import '../../../mocks/mocks.dart';

void main() {
  late IModularNavigator modularNavigatorMock;
  late ModularNavigationService service;

  setUp(() {
    modularNavigatorMock = MockModularNavigator();
    Modular.navigatorDelegate = modularNavigatorMock;
    service = ModularNavigationService();
  });

  group('goTo', () {
    test(
      'deve navegar para outra rota sem remover histórico.',
      () async {
        // arrange
        when(() => modularNavigatorMock.pushNamed('/home'))
            .thenAnswer((_) async => null);
        // act
        service.goTo('/home', replace: false);
        await untilCalled(() => modularNavigatorMock.pushNamed('/home'));
        // assert
        verify(() => modularNavigatorMock.pushNamed('/home')).called(1);
        verifyNever(() => modularNavigatorMock.navigate('/home'));
      },
    );

    test(
      'deve navegar para outra rota e remover histórico.',
      () {
        // act
        service.goTo('/home', replace: true);
        // assert
        verify(() => modularNavigatorMock.navigate('/home')).called(1);
        verifyNever(() => modularNavigatorMock.pushNamed('/home'));
      },
    );
  });

  group('goBack', () {
    test(
      'deve navegar para a rota anterior.',
      () {
        // arrange
        when(() => modularNavigatorMock.path).thenAnswer((_) => '/');
        // act
        service.goBack();
        // assert
        verify(() => modularNavigatorMock.pop());
      },
    );
  });

  group('currentRoute', () {
    test(
      'deve emitir a rota quando ocorrer uma navegação.',
      () {
        // act
        final stream = service.currentRoute();
        // assert
        expect(stream, emits('/home'));
        // act
        service.goTo('/home', replace: true);
      },
    );
  });
}
