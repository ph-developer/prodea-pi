import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/data/services/go_router_navigation_service.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GoRouter goRouterMock;
  late GoRouterNavigationService service;

  setUp(() {
    goRouterMock = MockGoRouter();
    service = GoRouterNavigationService(goRouterMock);
  });

  group('goTo', () {
    test(
      'deve navegar para outra rota sem remover histórico.',
      () async {
        // act
        service.goTo('/home', replace: false);
        await untilCalled(() => goRouterMock.push('/home'));
        // assert
        verify(() => goRouterMock.push('/home')).called(1);
        verifyNever(() => goRouterMock.replace('/home'));
      },
    );

    test(
      'deve navegar para outra rota e remover histórico.',
      () {
        // act
        service.goTo('/home', replace: true);
        // assert
        verify(() => goRouterMock.replace('/home')).called(1);
        verifyNever(() => goRouterMock.push('/home'));
      },
    );
  });

  group('goBack', () {
    test(
      'deve navegar para a rota anterior.',
      () {
        // arrange
        when(() => goRouterMock.location).thenAnswer((_) => '/');
        // act
        service.goBack();
        // assert
        verify(() => goRouterMock.pop());
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
