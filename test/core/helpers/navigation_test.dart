import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/helpers/navigation.dart';

class MockModularNavigator extends Mock implements IModularNavigator {}

void main() {
  late IModularNavigator modularNavigatorMock;

  setUp(() {
    modularNavigatorMock = MockModularNavigator();
    Modular.navigatorDelegate = modularNavigatorMock;
  });

  group('goTo', () {
    test(
      'deve navegar para outra rota sem remover histórico.',
      () async {
        // arrange
        when(() => modularNavigatorMock.pushNamed('/home'))
            .thenAnswer((_) async => null);
        // act
        NavigationHelper.goTo('/home', replace: false);
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
        NavigationHelper.goTo('/home', replace: true);
        // assert
        verify(() => modularNavigatorMock.navigate('/home')).called(1);
        verifyNever(() => modularNavigatorMock.pushNamed('/home'));
      },
    );
  });

  group('back', () {
    test(
      'deve navegar para a rota anterior.',
      () {
        // act
        NavigationHelper.back();
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
        final stream = NavigationHelper.currentRoute;
        // assert
        expect(stream, emits('/home'));
        // act
        NavigationHelper.goTo('/home', replace: true);
      },
    );
  });
}
