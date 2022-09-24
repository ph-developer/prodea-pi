import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/repositories/remote/firebase_user_remote_repo.dart';
import 'package:prodea/src/domain/entities/user.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FirebaseFirestore firestoreFake;
  late FirebaseUserRemoteRepo firebaseUserRemoteRepoWithFake;
  late FirebaseFirestore firestoreMock;
  late FirebaseUserRemoteRepo firebaseUserRemoteRepoWithMock;

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
    isBeneficiary: true,
    isAdmin: true,
    status: AuthorizationStatus.authorized,
  );

  final tUserMap = {
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

  setUp(() {
    firestoreFake = FakeFirebaseFirestore();
    firebaseUserRemoteRepoWithFake = FirebaseUserRemoteRepo(firestoreFake);
    firestoreMock = MockFirebaseFirestore();
    firebaseUserRemoteRepoWithMock = FirebaseUserRemoteRepo(firestoreMock);
  });

  group('getById', () {
    test(
      'deve retornar um UserInfo quando existir.',
      () async {
        // arrange
        firestoreFake.collection('userInfo').doc('id').set(tUserMap);
        // act
        final result = await firebaseUserRemoteRepoWithFake.getById('id');
        // assert
        expect(result, isA<User>());
        expect(result.id, tUser.id);
        expect(result.email, tUser.email);
        expect(result.status, tUser.status);
      },
    );

    test(
      'deve disparar uma GetUserInfoFailure quando o UserInfo não existir.',
      () async {
        // act
        final result = firebaseUserRemoteRepoWithFake.getById('not_exists');
        // assert
        expect(result, throwsA(isA<GetUserFailure>()));
      },
    );

    test(
      'deve disparar uma GetUserInfoFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => firestoreMock.collection(any())).thenThrow(Exception());
        // act
        final result = firebaseUserRemoteRepoWithMock.getById('id');
        // assert
        expect(result, throwsA(isA<GetUserFailure>()));
      },
    );
  });

  group('create', () {
    test(
      'deve retornar uma UserInfo quando obtiver sucesso na criação.',
      () async {
        // act
        final result = await firebaseUserRemoteRepoWithFake.create(tUser);
        // assert
        expect(result, isA<User>());
        expect(result.id, isA<String>());
        expect(result.email, tUser.email);
        expect(result.status, tUser.status);
      },
    );

    test(
      'deve disparar uma CreateUserInfoFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => firestoreMock.collection(any())).thenThrow(Exception());
        // act
        final result = firebaseUserRemoteRepoWithMock.create(tUser);
        // assert
        expect(result, throwsA(isA<CreateUserFailure>()));
      },
    );
  });

  group('update', () {
    test(
      'deve retornar uma UserInfo quando obtiver sucesso na alteração.',
      () async {
        // act
        final result = await firebaseUserRemoteRepoWithFake.update(tUser);
        // assert
        expect(result, isA<User>());
        expect(result.id, tUser.id);
        expect(result.email, tUser.email);
        expect(result.status, tUser.status);
      },
    );

    test(
      'deve disparar uma UpdateUserInfoFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => firestoreMock.collection(any())).thenThrow(Exception());
        // act
        final result = firebaseUserRemoteRepoWithMock.update(tUser);
        // assert
        expect(result, throwsA(isA<UpdateUserFailure>()));
      },
    );
  });

  group('getUserInfos', () {
    test(
      'deve retornar uma lista de UserInfos.',
      () async {
        // arrange
        firestoreFake.collection('donation').add(tUserMap);
        // act
        final stream = firebaseUserRemoteRepoWithFake.getUsers();
        // assert
        expect(stream, emits(isA<List<User>>()));
      },
    );
  });
}
