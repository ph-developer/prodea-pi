import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/repositories/firebase_auth_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

class MockFirebaseUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthCredential extends Mock implements AuthCredential {}

class MockUserInfoRepo extends Mock implements IUserInfoRepo {}

class MockNotificationService extends Mock implements INotificationService {}

void main() {
  late User userMock;
  late UserCredential userCredentialMock;
  late FirebaseAuth authMock;
  late IUserInfoRepo userInfoRepoMock;
  late INotificationService notificationServiceMock;
  late FirebaseAuthRepo firebaseAuthRepo;

  setUp(() {
    userMock = MockFirebaseUser();
    userCredentialMock = MockFirebaseUserCredential();
    authMock = MockFirebaseAuth();
    userInfoRepoMock = MockUserInfoRepo();
    notificationServiceMock = MockNotificationService();
    firebaseAuthRepo = FirebaseAuthRepo(
      authMock,
      userInfoRepoMock,
      notificationServiceMock,
    );

    registerFallbackValue(MockFirebaseAuthCredential());

    when(() => userMock.displayName).thenReturn("test");
    when(() => userMock.email).thenReturn("test@test.dev");
    when(() => userCredentialMock.user).thenReturn(userMock);
  });

  test('deve retornar true e não realizar nenhuma notificação.', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => userCredentialMock);
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, true);
    verifyNever(() => notificationServiceMock.notifyError(any()));
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (1)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('inexpected'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (2)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'inexpected'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (3)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'user-disabled'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (4)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'invalid-email'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (5)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (6)', () async {
    // arrange
    when(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
    // act
    final result = await firebaseAuthRepo.login('test', 'test@test.dev');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
  });

  test('deve retornar false e realizar uma notificação de erro. (7)', () async {
    // act
    final result = await firebaseAuthRepo.login('', '');
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
    verifyNever(() => authMock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });
}
