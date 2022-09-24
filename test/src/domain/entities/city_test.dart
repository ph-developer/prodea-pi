import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/entities/city.dart';

void main() {
  const tModel = City(name: 'name', uf: 'uf');

  test(
    'deve retornar true quando os atributos forem iguais.',
    () {
      // arrange
      const tOtherModel = City(name: 'name', uf: 'uf');
      // act
      final result = tModel == tOtherModel;
      // assert
      expect(result, true);
    },
  );

  test(
    'deve retornar false quando ao menos um dos atributos for diferente.',
    () {
      // arrange
      const tOtherModel = City(name: 'other_name', uf: 'uf');
      // act
      final result = tModel == tOtherModel;
      // assert
      expect(result, false);
    },
  );
}
