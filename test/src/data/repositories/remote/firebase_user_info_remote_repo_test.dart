import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/repositories/remote/firebase_user_info_remote_repo.dart';
import 'package:prodea/src/domain/entities/user_info.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FirebaseFirestore firestoreFake;
  late FirebaseUserInfoRemoteRepo firebaseUserInfoRemoteRepoWithFake;
  late FirebaseFirestore firestoreMock;
  late FirebaseUserInfoRemoteRepo firebaseUserInfoRemoteRepoWithMock;

  const tUserInfo = UserInfo(
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

  final tUserInfoMap = {
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
    firebaseUserInfoRemoteRepoWithFake =
        FirebaseUserInfoRemoteRepo(firestoreFake);
    firestoreMock = MockFirebaseFirestore();
    firebaseUserInfoRemoteRepoWithMock =
        FirebaseUserInfoRemoteRepo(firestoreMock);
  });

  group('getById', () {
    test('deve retornar um UserInfo quando existir.', () async {
      // arrange
      firestoreFake.collection('userInfo').doc('id').set(tUserInfoMap);
      // act
      final result = await firebaseUserInfoRemoteRepoWithFake.getById('id');
      // assert
      expect(result, isA<UserInfo>());
      expect(result.id, tUserInfo.id);
      expect(result.email, tUserInfo.email);
      expect(result.status, tUserInfo.status);
    });

    test('deve disparar uma GetUserInfoFailure quando o UserInfo não existir.',
        () async {
      // act
      final result = firebaseUserInfoRemoteRepoWithFake.getById('not_exists');
      // assert
      expect(result, throwsA(isA<GetUserInfoFailure>()));
    });

    test('deve disparar uma GetUserInfoFailure quando ocorrer algum erro.', () {
      // arrange
      when(() => firestoreMock.collection(any())).thenThrow(Exception());
      // act
      final result = firebaseUserInfoRemoteRepoWithMock.getById('id');
      // assert
      expect(result, throwsA(isA<GetUserInfoFailure>()));
    });
  });

  group('create', () {
    test('deve retornar uma UserInfo quando obtiver sucesso na criação.',
        () async {
      // act
      final result = await firebaseUserInfoRemoteRepoWithFake.create(tUserInfo);
      // assert
      expect(result, isA<UserInfo>());
      expect(result.id, isA<String>());
      expect(result.email, tUserInfo.email);
      expect(result.status, tUserInfo.status);
    });

    test('deve disparar uma CreateUserInfoFailure quando ocorrer algum erro.',
        () {
      // arrange
      when(() => firestoreMock.collection(any())).thenThrow(Exception());
      // act
      final result = firebaseUserInfoRemoteRepoWithMock.create(tUserInfo);
      // assert
      expect(result, throwsA(isA<CreateUserInfoFailure>()));
    });
  });

  group('update', () {
    test('deve retornar uma UserInfo quando obtiver sucesso na alteração.',
        () async {
      // act
      final result = await firebaseUserInfoRemoteRepoWithFake.update(tUserInfo);
      // assert
      expect(result, isA<UserInfo>());
      expect(result.id, tUserInfo.id);
      expect(result.email, tUserInfo.email);
      expect(result.status, tUserInfo.status);
    });

    test('deve disparar uma UpdateUserInfoFailure quando ocorrer algum erro.',
        () {
      // arrange
      when(() => firestoreMock.collection(any())).thenThrow(Exception());
      // act
      final result = firebaseUserInfoRemoteRepoWithMock.update(tUserInfo);
      // assert
      expect(result, throwsA(isA<UpdateUserInfoFailure>()));
    });
  });

  group('getUserInfos', () {
    test('deve retornar uma lista de UserInfos.', () async {
      // arrange
      firestoreFake.collection('donation').add(tUserInfoMap);
      // act
      final stream = firebaseUserInfoRemoteRepoWithFake.getUserInfos();
      // assert
      expect(stream, emits(isA<List<UserInfo>>()));
    });
  });
}
