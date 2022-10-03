import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/services/navigation_service.dart';
import 'package:prodea/src/domain/usecases/navigation/get_current_route.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late INavigationService navigationServiceMock;
  late GetCurrentRoute usecase;

  setUp(() {
    navigationServiceMock = MockNavigationService();
    usecase = GetCurrentRoute(navigationServiceMock);
  });

  test(
    'deve emitir uma string contendo a rota atual.',
    () {
      // arrange
      when(navigationServiceMock.currentRoute)
          .thenAnswer((_) => Stream.fromIterable(['/']));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<String>()));
      expect(stream, emits('/'));
    },
  );
}
