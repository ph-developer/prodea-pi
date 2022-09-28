import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/usecases/user/get_beneficiaries.dart';
import 'package:prodea/src/domain/usecases/user/get_common_users.dart';
import 'package:prodea/src/domain/usecases/user/get_donors.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_authorized.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_denied.dart';
import 'package:prodea/src/presentation/stores/users_store.dart';

import '../../../test_helpers/mobx.dart';

class MockGetCommonUsers extends Mock implements GetCommonUsers {}

class MockGetBeneficiaries extends Mock implements GetBeneficiaries {}

class MockGetDonors extends Mock implements GetDonors {}

class MockSetUserAsAuthorized extends Mock implements SetUserAsAuthorized {}

class MockSetUserAsDenied extends Mock implements SetUserAsDenied {}

void main() {
  late GetCommonUsers getCommonUsersMock;
  late GetBeneficiaries getBeneficiariesMock;
  late GetDonors getDonorsMock;
  late SetUserAsAuthorized setUserAsAuthorizedMock;
  late SetUserAsDenied setUserAsDeniedMock;
  late UsersStore store;

  const tUser = User(
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
  final tUserList = [tUser];

  setUp(() {
    getCommonUsersMock = MockGetCommonUsers();
    getBeneficiariesMock = MockGetBeneficiaries();
    getDonorsMock = MockGetDonors();
    setUserAsAuthorizedMock = MockSetUserAsAuthorized();
    setUserAsDeniedMock = MockSetUserAsDenied();
    store = UsersStore(
      getCommonUsersMock,
      getBeneficiariesMock,
      getDonorsMock,
      setUserAsAuthorizedMock,
      setUserAsDeniedMock,
    );
  });

  group('fetchUsers', () {
    test(
      'deve inicializar a store, populando as listas de usuários.',
      () async {
        // arrange
        when(getCommonUsersMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getBeneficiariesMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getDonorsMock).thenAnswer((_) => Stream.fromIterable([tUserList]));
        final commonUsersChanged = MockCallable<List<User>>();
        final beneficiariesChanged = MockCallable<List<User>>();
        final donorsChanged = MockCallable<List<User>>();
        whenReaction((_) => store.commonUsers, commonUsersChanged);
        whenReaction((_) => store.beneficiaries, beneficiariesChanged);
        whenReaction((_) => store.donors, donorsChanged);
        // assert
        expect(store.commonUsers, equals([]));
        expect(store.beneficiaries, equals([]));
        expect(store.donors, equals([]));
        // act
        store.fetchUsers();
        await untilCalled(() => commonUsersChanged(tUserList));
        await untilCalled(() => beneficiariesChanged(tUserList));
        await untilCalled(() => donorsChanged(tUserList));
        // assert
        expect(store.commonUsers, tUserList);
        expect(store.beneficiaries, tUserList);
        expect(store.donors, tUserList);
      },
    );
  });

  group('getDonorById', () {
    test(
      'deve retornar um doador por id caso este esteja na lista de doadores.',
      () async {
        // arrange
        when(getCommonUsersMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getBeneficiariesMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getDonorsMock).thenAnswer((_) => Stream.fromIterable([tUserList]));
        final donorsChanged = MockCallable<List<User>>();
        whenReaction((_) => store.donors, donorsChanged);
        // act
        store.fetchUsers();
        await untilCalled(() => donorsChanged(tUserList));
        final result = store.getDonorById('id');
        // assert
        expect(result, tUser);
      },
    );
  });

  group('getBeneficiaryById', () {
    test(
      'deve retornar um beneficiário por id caso este esteja na lista de beneficiários.',
      () async {
        // arrange
        when(getCommonUsersMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getBeneficiariesMock)
            .thenAnswer((_) => Stream.fromIterable([tUserList]));
        when(getDonorsMock).thenAnswer((_) => Stream.fromIterable([tUserList]));
        final beneficiariesChanged = MockCallable<List<User>>();
        whenReaction((_) => store.beneficiaries, beneficiariesChanged);
        // act
        store.fetchUsers();
        await untilCalled(() => beneficiariesChanged(tUserList));
        final result = store.getBeneficiaryById('id');
        // assert
        expect(result, tUser);
      },
    );
  });

  group('setUserAsAuthorized', () {
    test(
      'deve chamar a usecase para marcar o usuário como autorizado.',
      () async {
        // arrange
        when(() => setUserAsAuthorizedMock(tUser))
            .thenAnswer((_) async => tUser);
        // act
        await store.setUserAsAuthorized(tUser);
        // assert
        verify(() => setUserAsAuthorizedMock(tUser)).called(1);
      },
    );
  });

  group('setUserAsDenied', () {
    test(
      'deve chamar a usecase para marcar o usuário como não autorizado.',
      () async {
        // arrange
        when(() => setUserAsDeniedMock(tUser)).thenAnswer((_) async => tUser);
        // act
        await store.setUserAsDenied(tUser);
        // assert
        verify(() => setUserAsDeniedMock(tUser)).called(1);
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = store.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
