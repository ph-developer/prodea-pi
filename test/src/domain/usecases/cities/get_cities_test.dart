import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/city.dart';
import 'package:prodea/src/domain/repositories/city_repo.dart';
import 'package:prodea/src/domain/usecases/cities/get_cities.dart';

class MockCityRepo extends Mock implements ICityRepo {}

void main() {
  late ICityRepo cityRepoMock;
  late GetCities usecase;

  const tCity1 = City(name: 'Penápolis', uf: 'SP');
  const tCity2 = City(name: 'Araçatuba', uf: 'SP');

  setUp(() {
    cityRepoMock = MockCityRepo();
    usecase = GetCities(cityRepoMock);
  });

  test(
    'deve emitir uma lista de cidades ordenada por nome.',
    () {
      // arrange
      when(cityRepoMock.getCities).thenAnswer((_) => Stream.fromIterable([
            [tCity1, tCity2]
          ]));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<List<City>>()));
      expect(stream, emits([tCity2, tCity1]));
    },
  );
}
