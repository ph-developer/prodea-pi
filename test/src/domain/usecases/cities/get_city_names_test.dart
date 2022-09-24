import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/dtos/city_dto.dart';
import 'package:prodea/src/domain/entities/city.dart';
import 'package:prodea/src/domain/repositories/city_repo.dart';
import 'package:prodea/src/domain/usecases/cities/get_city_names.dart';

class MockCityRepo extends Mock implements ICityRepo {}

void main() {
  late ICityRepo cityRepoMock;
  late GetCityNames usecase;

  const tCity1 = City(name: 'Penápolis', uf: 'SP');
  const tCity2 = City(name: 'Araçatuba', uf: 'SP');

  setUp(() {
    cityRepoMock = MockCityRepo();
    usecase = GetCityNames(cityRepoMock);
  });

  test(
    'deve emitir uma lista de nomes de cidades ordenada.',
    () {
      // arrange
      when(cityRepoMock.getCities).thenAnswer((_) => Stream.fromIterable([
            [tCity1, tCity2]
          ]));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<List<String>>()));
      expect(stream, emits([tCity2.value, tCity1.value]));
    },
  );
}
