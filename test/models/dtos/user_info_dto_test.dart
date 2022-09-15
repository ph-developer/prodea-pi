import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/models/dtos/user_info_dto.dart';
import 'package:prodea/models/user_info.dart';

void main() {
  final tModel = UserInfo(
    id: 'id',
    _email: 'email',
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

  test('deve fazer uma cópia do model, alterando os atributos.', () {
    // act
    final result1 = tModel.copyWith(
      id: 'id2',
      _email: 'email2',
    );
    final result2 = tModel.copyWith(
      status: AuthorizationStatus.denied,
    );
    // assert
    expect(result1, isA<UserInfo>());
    expect(result1.id, 'id2');
    expect(result1._email, 'email2');
    expect(result2, isA<UserInfo>());
    expect(result2.status, AuthorizationStatus.denied);
  });

  test('deve retornar um map com os atributos do model.', () {
    // act
    final result = tModel.toMap();
    // assert
    expect(result, isA<Map<String, dynamic>>());
    expect(result['id'], tModel.id);
    expect(result['email'], tModel._email);
    expect(result['status'], tModel.status.statusCode);
  });

  test('deve retornar um model com os atributos do map.', () {
    // act
    final result = UserInfoDTO.fromMap(tMap);
    // assert
    expect(result, isA<UserInfo>());
    expect(result.id, tMap['id']);
    expect(result._email, tMap['email']);
    expect(result.status.statusCode, tMap['status']);
  });
}
