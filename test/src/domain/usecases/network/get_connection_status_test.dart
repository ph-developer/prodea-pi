import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/services/network_service.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/network/get_connection_status.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late INotificationService notificationServiceMock;
  late INetworkService networkServiceMock;
  late GetConnectionStatus usecase;

  setUp(() {
    notificationServiceMock = MockNotificationService();
    networkServiceMock = MockNetworkService();
    usecase = GetConnectionStatus(networkServiceMock, notificationServiceMock);
  });

  test(
    'deve emitir true quando tiver conexão com a internet.',
    () {
      // arrange
      when(networkServiceMock.isConnected).thenAnswer((_) async => true);
      // act
      final stream = usecase(1);
      // assert
      expect(stream, emitsInOrder([true, true, true]));
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve emitir false quando não tiver conexão com a internet.',
    () {
      // arrange
      when(networkServiceMock.isConnected).thenAnswer((_) async => false);
      // act
      final stream = usecase(1);
      // assert
      expect(stream, emitsInOrder([false, false, false]));
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve emitir false e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(networkServiceMock.isConnected)
          .thenThrow(InternetConnectionFailure());
      // act
      final stream = usecase(1);
      // assert
      expect(stream, emitsInOrder([false, false, false]));
      await untilCalled(() => notificationServiceMock.notifyError(any()));
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
