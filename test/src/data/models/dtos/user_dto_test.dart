import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/dtos/user_dto.dart';
import 'package:prodea/src/domain/entities/user.dart';

void main() {
  const tModel = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'name',
    address: 'address',
    city: 'city',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: true,
    isAdmin: true,
    status: AuthorizationStatus.authorized,
  );

  const tMap = {
    'id': 'id',
    'email': 'email',
    'cnpj': 'cnpj',
    'name': 'name',
    'address': 'address',
    'city': 'city',
    'phoneNumber': 'phoneNumber',
    'about': 'about',
    'responsibleName': 'responsibleName',
    'responsibleCpf': 'responsibleCpf',
    'isDonor': true,
    'isBeneficiary': true,
    'isAdmin': true,
    'status': 1,
  };

  group('toMap', () {
    test(
      'deve retornar um map com os atributos do model, exceto o id.',
      () {
        // act
        final result = tModel.toMap();
        // assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], null);
        expect(result['email'], tModel.email);
        expect(result['status'], tModel.status.statusCode);
      },
    );
  });

  group('fromMap', () {
    test(
      'deve retornar um model com os atributos do map.',
      () {
        // act
        final result = UserDTO.fromMap(tMap);
        // assert
        expect(result, isA<User>());
        expect(result.id, tMap['id']);
        expect(result.email, tMap['email']);
        expect(result.status.statusCode, tMap['status']);
      },
    );
  });
}
