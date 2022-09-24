import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/repositories/local/json_city_local_repo.dart';
import 'package:prodea/src/domain/entities/city.dart';

void main() {
  late JsonCityLocalRepo jsonCityLocalRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    jsonCityLocalRepo = JsonCityLocalRepo();
  });

  group('getCities', () {
    test(
      'deve retornar uma lista de cidades.',
      () async {
        // act
        final stream = jsonCityLocalRepo.getCities();
        // assert
        expect(stream, emits(isA<List<City>>()));
      },
    );
  });
}
