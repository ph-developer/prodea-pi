import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/usecases/cities/get_city_names.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GetCityNames getCityNamesMock;
  late CitiesStore store;

  const tCityNameList = [
    'Penápolis/SP',
    'Araçatuba/SP',
  ];

  setUp(() {
    getCityNamesMock = MockGetCityNames();
    store = CitiesStore(getCityNamesMock);
  });

  group('fetchCities', () {
    test(
      'deve inicializar a store, populando a lista de cidades.',
      () async {
        // arrange
        when(getCityNamesMock)
            .thenAnswer((_) => Stream.fromIterable([tCityNameList]));
        final citiesChanged = MockCallable<List<String>>();
        whenReaction((_) => store.cities, citiesChanged);
        // assert
        expect(store.cities, equals([]));
        // act
        store.fetchCities();
        await untilCalled(() => citiesChanged(tCityNameList));
        // assert
        expect(store.cities, tCityNameList);
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = store.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
