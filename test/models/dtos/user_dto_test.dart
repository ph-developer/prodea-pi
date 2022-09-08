import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/models/dtos/user_dto.dart';
import 'package:prodea/models/user.dart';

void main() {
  final tModel = User(
    id: 'id',
    email: 'email',
  );

  const tMap = {
    'id': 'id',
    'email': 'email',
  };

  test('deve fazer uma cópia do model, alterando os atributos.', () {
    // act
    final result1 = tModel.copyWith(
      id: 'id2',
    );
    final result2 = tModel.copyWith(
      email: 'email2',
    );
    // assert
    expect(result1, isA<User>());
    expect(result1.id, 'id2');
    expect(result2, isA<User>());
    expect(result2.email, 'email2');
  });

  test('deve retornar um map com os atributos do model.', () {
    // act
    final result = tModel.toMap();
    // assert
    expect(result, isA<Map<String, dynamic>>());
    expect(result['id'], tModel.id);
    expect(result['email'], tModel.email);
  });

  test('deve retornar um model com os atributos do map.', () {
    // act
    final result = UserDTO.fromMap(tMap);
    // assert
    expect(result, isA<User>());
    expect(result.id, tMap['id']);
    expect(result.email, tMap['email']);
  });
}
