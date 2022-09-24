import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/usecases/cities/get_city_names.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

import '../../../test_helpers/mobx.dart';

class MockGetCityNames extends Mock implements GetCityNames {}

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
      store.init();
      await untilCalled(() => citiesChanged(tCityNameList));
      // assert
      expect(store.cities, tCityNameList);
    },
  );

  test(
    'deve retornar uma string.',
    () {
      // act
      final result = store.toString();
      // assert
      expect(result, isA<String>());
    },
  );
}
