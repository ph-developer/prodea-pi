import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as firebase show User;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/repositories/remote/firebase_auth_remote_repo.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase.User {}

class MockFirebaseUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthCredential extends Mock implements AuthCredential {}

void main() {
  late firebase.User userMock;
  late UserCredential userCredentialMock;
  late UserCredential nullCredentialMock;
  late FirebaseAuth authMock;
  late FirebaseAuthRemoteRepo firebaseAuthRemoteRepo;

  setUp(() {
    userMock = MockFirebaseUser();
    userCredentialMock = MockFirebaseUserCredential();
    nullCredentialMock = MockFirebaseUserCredential();
    authMock = MockFirebaseAuth();
    firebaseAuthRemoteRepo = FirebaseAuthRemoteRepo(authMock);

    registerFallbackValue(MockFirebaseAuthCredential());

    when(() => userMock.uid).thenReturn("test");
    when(() => userMock.email).thenReturn("test@test.dev");
    when(() => userCredentialMock.user).thenReturn(userMock);
    when(() => nullCredentialMock.user).thenReturn(null);
  });

  group('login', () {
    test('deve retornar o id do usuário quando o login for bem sucedido.',
        () async {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => userCredentialMock);
      // act
      final result =
          await firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, isA<String>());
    });

    test('deve disparar uma LoginFailure quando o usuário estiver bloqueado.',
        () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'user-disabled'));
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });

    test('deve disparar uma LoginFailure quando o email for inválido.', () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'invalid-email'));
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });

    test('deve disparar uma LoginFailure quando o usuário não for encontrado.',
        () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });

    test('deve disparar uma LoginFailure quando a senha estiver incorreta.',
        () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });

    test('deve disparar uma LoginFailure quando o login retornar null.', () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => nullCredentialMock);
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });

    test('deve disparar uma LoginFailure quando ocorrer um erro inesperado.',
        () {
      // arrange
      when(() => authMock.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception());
      // act
      final result = firebaseAuthRemoteRepo.login('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<LoginFailure>()));
    });
  });

  group('register', () {
    test('deve retornar o id do usuário quando o registro for bem sucedido.',
        () async {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => userCredentialMock);
      // act
      final result =
          await firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, isA<String>());
    });

    test('deve disparar uma RegisterFailure quando o email estiver em uso.',
        () {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      // act
      final result = firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<RegisterFailure>()));
    });

    test('deve disparar uma RegisterFailure quando o email for inválido.', () {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'invalid-email'));
      // act
      final result = firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<RegisterFailure>()));
    });

    test('deve disparar uma RegisterFailure quando a senha for fraca.', () {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'weak-password'));
      // act
      final result = firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<RegisterFailure>()));
    });

    test('deve disparar uma RegisterFailure quando o registro retornar null.',
        () {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => nullCredentialMock);
      // act
      final result = firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<RegisterFailure>()));
    });

    test('deve disparar uma RegisterFailure quando ocorrer um erro inesperado.',
        () {
      // arrange
      when(() => authMock.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception());
      // act
      final result = firebaseAuthRemoteRepo.register('test@test.dev', 'test');
      // assert
      expect(result, throwsA(isA<RegisterFailure>()));
    });
  });

  group('sendPasswordResetEmail', () {
    test(
        'deve retornar true quando o email de redefinição de senha for enviado.',
        () async {
      // arrange
      when(() => authMock.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenAnswer((_) async {});
      // act
      final result =
          await firebaseAuthRemoteRepo.sendPasswordResetEmail('test@test.dev');
      // assert
      expect(result, isA<bool>());
      expect(result, true);
    });

    test('deve disparar uma PasswordResetFailure quando o email for inválido.',
        () {
      // arrange
      when(() => authMock.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenThrow(FirebaseAuthException(code: 'auth/invalid-email'));
      // act
      final result =
          firebaseAuthRemoteRepo.sendPasswordResetEmail('test@test.dev');
      // assert
      expect(result, throwsA(isA<PasswordResetFailure>()));
    });

    test(
        'deve disparar uma PasswordResetFailure quando o usuário não for encontrado.',
        () {
      // arrange
      when(() => authMock.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenThrow(FirebaseAuthException(code: 'auth/user-not-found'));
      // act
      final result =
          firebaseAuthRemoteRepo.sendPasswordResetEmail('test@test.dev');
      // assert
      expect(result, throwsA(isA<PasswordResetFailure>()));
    });

    test(
        'deve disparar uma PasswordResetFailure quando ocorrer um erro inesperado.',
        () {
      // arrange
      when(() => authMock.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenThrow(Exception());
      // act
      final result =
          firebaseAuthRemoteRepo.sendPasswordResetEmail('test@test.dev');
      // assert
      expect(result, throwsA(isA<PasswordResetFailure>()));
    });
  });

  group('logout', () {
    test('deve retornar true quando o logout for bem sucedido.', () async {
      // arrange
      when(() => authMock.signOut()).thenAnswer((_) async {});
      // act
      final result = await firebaseAuthRemoteRepo.logout();
      // assert
      expect(result, isA<bool>());
      expect(result, true);
    });

    test('deve disparar uma LogoutFailure quando ocorrer um erro.', () {
      // arrange
      when(() => authMock.signOut()).thenThrow(Exception());
      // act
      final result = firebaseAuthRemoteRepo.logout();
      // assert
      expect(result, throwsA(isA<LogoutFailure>()));
    });
  });

  group('getCurrentUserId', () {
    test('deve retornar o id do usuário se ele estiver autenticado.', () async {
      // arrange
      when(() => authMock.currentUser).thenAnswer((_) => null);
      when(authMock.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([userMock]));
      // act
      final result = await firebaseAuthRemoteRepo.getCurrentUserId();
      // assert
      expect(result, isA<String>());
    });

    test('deve retornar null quando o usuário não estiver autenticado.',
        () async {
      // arrange
      when(() => authMock.currentUser).thenAnswer((_) => null);
      when(authMock.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([null]));
      // act
      final result = await firebaseAuthRemoteRepo.getCurrentUserId();
      // assert
      expect(result, isNull);
    });
  });

  group('currentUserIdChanged', () {
    test('deve retornar o id do usuário quando efetuar o login.', () {
      // arrange
      when(authMock.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([userMock]));
      // act
      final stream = firebaseAuthRemoteRepo.currentUserIdChanged();
      // assert
      expect(stream, emits(isA<String>()));
    });

    test('deve retornar null quando o usuário efetuar o logout.', () {
      // arrange
      when(authMock.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([null]));
      // act
      final stream = firebaseAuthRemoteRepo.currentUserIdChanged();
      // assert
      expect(stream, emits(null));
    });
  });
}
