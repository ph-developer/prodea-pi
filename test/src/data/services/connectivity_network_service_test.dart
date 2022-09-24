import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/services/connectivity_network_service.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late Connectivity connectivityMock;
  late ConnectivityNetworkService connectivityNetworkService;

  setUp(() {
    connectivityMock = MockConnectivity();
    connectivityNetworkService = ConnectivityNetworkService(connectivityMock);
  });

  group('isConnected', () {
    test(
      'deve retornar true quando tiver conexão com a internet.',
      () async {
        // arrange
        when(() => connectivityMock.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        // act
        final result = await connectivityNetworkService.isConnected();
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false quando tiver não conexão com a internet.',
      () async {
        // arrange
        when(() => connectivityMock.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);
        // act
        final result = await connectivityNetworkService.isConnected();
        // assert
        expect(result, false);
      },
    );

    test(
      'deve disparar uma InternetConnectionFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => connectivityMock.checkConnectivity()).thenThrow(Exception());
        // act
        final result = connectivityNetworkService.isConnected();
        // assert
        expect(result, throwsA(isA<InternetConnectionFailure>()));
      },
    );
  });
}
