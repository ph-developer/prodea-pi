import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/dtos/user_dto.dart';
import 'package:prodea/src/domain/entities/user.dart';

void main() {
  const tModel = User(
    id: 'id',
    email: 'email',
  );

  const tMap = {
    'id': 'id',
    'email': 'email',
  };

  group('toMap', () {
    test('deve retornar um map com os atributos do model.', () {
      // act
      final result = tModel.toMap();
      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], tModel.id);
      expect(result['email'], tModel.email);
    });
  });

  group('fromMap', () {
    test('deve retornar um model com os atributos do map.', () {
      // act
      final result = UserDTO.fromMap(tMap);
      // assert
      expect(result, isA<User>());
      expect(result.id, tMap['id']);
      expect(result.email, tMap['email']);
    });
  });
}
