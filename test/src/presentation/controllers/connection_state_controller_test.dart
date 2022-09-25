import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/usecases/network/get_connection_status.dart';
import 'package:prodea/src/presentation/controllers/connection_state_controller.dart';

import '../../../test_helpers/mobx.dart';

class MockGetConnectionStatus extends Mock implements GetConnectionStatus {}

void main() {
  late GetConnectionStatus getConnectionStatusMock;
  late ConnectionStateController controller;

  setUp(() {
    getConnectionStatusMock = MockGetConnectionStatus();

    when(getConnectionStatusMock).thenAnswer((_) => const Stream<bool>.empty());

    controller = ConnectionStateController(getConnectionStatusMock);
  });

  group('init', () {
    test(
      'deve inicializar o controller, e setar o status de conexão como true quando houver conexão.',
      () async {
        // arrange
        when(getConnectionStatusMock)
            .thenAnswer((_) => Stream.fromIterable([false, true]));
        final isConnectionChanged = MockCallable<bool>();
        whenReaction((_) => controller.isConnected, isConnectionChanged);
        // act
        controller.init();
        await untilCalled(() => isConnectionChanged(true));
        // assert
        expect(controller.isConnected, true);
      },
    );

    test(
      'deve inicializar o controller, e setar o status de conexão como false quando não houver conexão.',
      () async {
        // arrange
        when(getConnectionStatusMock)
            .thenAnswer((_) => Stream.fromIterable([false]));
        final isConnectionChanged = MockCallable<bool>();
        whenReaction((_) => controller.isConnected, isConnectionChanged);
        // act
        controller.init();
        await untilCalled(() => isConnectionChanged(false));
        // assert
        expect(controller.isConnected, false);
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
