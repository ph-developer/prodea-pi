import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/usecases/user/get_common_users.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IUserRepo userRepoMock;
  late GetCommonUsers usecase;

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
  const tUserWrong = User(
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
    isAdmin: true,
    status: AuthorizationStatus.authorized,
  );

  setUp(() {
    userRepoMock = MockUserRepo();
    usecase = GetCommonUsers(userRepoMock);
  });

  test(
    'deve retornar uma lista de usuários que não são administradores.',
    () {
      // arrange
      when(userRepoMock.getUsers).thenAnswer((_) => Stream.fromIterable([
            [tUserOk, tUserWrong]
          ]));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<List<User>>()));
      expect(stream, emits([tUserOk]));
    },
  );
}
