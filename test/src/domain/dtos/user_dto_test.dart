import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/dtos/user_dto.dart';
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

  group('copyWith', () {
    test('deve fazer uma cópia do model, alterando os atributos.', () {
      // act
      final result1 = tModel.copyWith(
        id: 'id2',
        email: 'email2',
      );
      final result2 = tModel.copyWith(
        status: AuthorizationStatus.denied,
      );
      // assert
      expect(result1, isA<User>());
      expect(result1.id, 'id2');
      expect(result1.email, 'email2');
      expect(result2, isA<User>());
      expect(result2.status, AuthorizationStatus.denied);
    });
  });
}
