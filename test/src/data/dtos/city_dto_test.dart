import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/dtos/city_dto.dart';
import 'package:prodea/src/domain/entities/city.dart';

void main() {
  const tModel = City(
    name: 'name',
    uf: 'UF',
  );

  const tMap = {
    'name': 'name',
    'uf': 'UF',
  };

  group('toMap', () {
    test('deve retornar um map com os atributos do model.', () {
      // act
      final result = tModel.toMap();
      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], tModel.name);
      expect(result['uf'], tModel.uf);
    });
  });

  group('fromMap', () {
    test('deve retornar um model com os atributos do map.', () {
      // act
      final result = CityDTO.fromMap(tMap);
      // assert
      expect(result, isA<City>());
      expect(result.name, tMap['name']);
      expect(result.uf, tMap['uf']);
    });
  });
}
