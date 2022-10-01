import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/usecases/user/get_beneficiaries.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IUserRepo userRepoMock;
  late GetBeneficiaries usecase;

  const tUserOk = User(
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
    isDonor: false,
    isBeneficiary: true,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );
  const tUserWrong1 = User(
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
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );
  const tUserWrong2 = User(
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
    isDonor: false,
    isBeneficiary: true,
    isAdmin: false,
    status: AuthorizationStatus.denied,
  );
  const tUserWrong3 = User(
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
    isDonor: false,
    isBeneficiary: true,
    isAdmin: false,
    status: AuthorizationStatus.waiting,
  );

  setUp(() {
    userRepoMock = MockUserRepo();
    usecase = GetBeneficiaries(userRepoMock);
  });

  test(
    'deve retornar uma lista de usuários que são beneficiários e estão autorizados.',
    () {
      // arrange
      when(userRepoMock.getUsers).thenAnswer((_) => Stream.fromIterable([
            [tUserOk, tUserWrong1, tUserWrong2, tUserWrong3]
          ]));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<List<User>>()));
      expect(stream, emits([tUserOk]));
    },
  );
}
