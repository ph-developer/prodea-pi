import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/dtos/city_dto.dart';
import 'package:prodea/src/domain/entities/city.dart';

void main() {
  const tModel = City(
    name: 'name',
    uf: 'uf',
  );

  group('copyWith', () {
    test(
      'deve fazer uma cópia do model, alterando os atributos.',
      () {
        // act
        final result1 = tModel.copyWith(
          name: 'name2',
        );
        final result2 = tModel.copyWith(
          uf: 'uf2',
        );
        // assert
        expect(result1, isA<City>());
        expect(result1.name, 'name2');
        expect(result2, isA<City>());
        expect(result2.uf, 'uf2');
      },
    );
  });

  group('value', () {
    test(
      'deve retornar uma string no formato name/uf.',
      () {
        // act
        final result = tModel.value;
        // assert
        expect(result, "${tModel.name}/${tModel.uf}");
      },
    );
  });
}
