import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/services/navigation_service.dart';
import 'package:prodea/src/domain/usecases/navigation/go_to.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late INavigationService navigationServiceMock;
  late GoTo usecase;

  setUp(() {
    navigationServiceMock = MockNavigationService();
    usecase = GoTo(navigationServiceMock);
  });

  test(
    'deve navegar para a rota home sem erros, usando o modo replace.',
    () {
      // act
      usecase('/', replace: true);
      // assert
      verify(() => navigationServiceMock.goTo('/', replace: true)).called(1);
    },
  );

  test(
    'deve navegar para a rota home sem erros, sem usar o modo replace.',
    () {
      // act
      usecase('/');
      // assert
      verify(() => navigationServiceMock.goTo('/', replace: false)).called(1);
    },
  );
}
