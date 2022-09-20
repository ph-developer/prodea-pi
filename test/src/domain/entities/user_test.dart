import 'package:flutter_test/flutter_test.dart';
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

  test('deve retornar true quando os atributos forem iguais.', () {
    // arrange
    const tOtherModel = User(
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
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, true);
  });

  test('deve retornar false quando ao menos um dos atributos for diferente.',
      () {
    // arrange
    const tOtherModel = User(
      id: 'id',
      email: 'other_email',
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
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, false);
  });
}
