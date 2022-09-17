import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/entities/user.dart';

void main() {
  const tModel = User(id: 'id', email: 'email');

  test('deve retornar true quando os atributos forem iguais.', () {
    // arrange
    const tOtherModel = User(id: 'id', email: 'email');
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, true);
  });

  test('deve retornar false quando ao menos um dos atributos for diferente.',
      () {
    // arrange
    const tOtherModel = User(id: 'other_id', email: 'email');
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, false);
  });
}
