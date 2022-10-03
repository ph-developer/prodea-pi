import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/services/navigation_service.dart';
import 'package:prodea/src/domain/usecases/navigation/go_back.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late INavigationService navigationServiceMock;
  late GoBack usecase;

  setUp(() {
    navigationServiceMock = MockNavigationService();
    usecase = GoBack(navigationServiceMock);
  });

  test(
    'deve navegar para a rota anterior sem erros.',
    () {
      // act
      usecase();
      // assert
      verify(navigationServiceMock.goBack).called(1);
    },
  );
}
