import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/usecases/auth/do_login.dart';
import 'package:prodea/src/domain/usecases/auth/do_logout.dart';
import 'package:prodea/src/domain/usecases/auth/do_register.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';
import 'package:prodea/src/domain/usecases/auth/send_password_reset_email.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GetCurrentUser getCurrentUserMock;
  late DoLogin doLoginMock;
  late DoRegister doRegisterMock;
  late DoLogout doLogoutMock;
  late SendPasswordResetEmail sendPasswordResetEmailMock;
  late AuthController controller;

  const tAuthorizedDonorUser = User(
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

  const tAuthorizedBeneficiaryUser = User(
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
    isAdmin: true,
    status: AuthorizationStatus.authorized,
  );

  const tDeniedUser = User(
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
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.denied,
  );

  setUp(() {
    getCurrentUserMock = MockGetCurrentUser();
    doLoginMock = MockDoLogin();
    doRegisterMock = MockDoRegister();
    doLogoutMock = MockDoLogout();
    sendPasswordResetEmailMock = MockSendPasswordResetEmail();

    controller = AuthController(
      getCurrentUserMock,
      doLoginMock,
      doRegisterMock,
      doLogoutMock,
      sendPasswordResetEmailMock,
    );
  });

  group('isLoggedIn', () {
    test(
      'deve retornar true se houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = tAuthorizedDonorUser;
        final result = controller.isLoggedIn;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isLoggedIn;
        // assert
        expect(result, false);
      },
    );
  });

  group('isAdmin', () {
    test(
      'deve retornar true se houver um usuário autenticado e for um admin.',
      () {
        // act
        controller.currentUser = tAuthorizedDonorUser;
        final result = controller.isAdmin;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se houver um usuário autenticado e não for um admin.',
      () {
        // act
        controller.currentUser = tDeniedUser;
        final result = controller.isAdmin;
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isAdmin;
        // assert
        expect(result, false);
      },
    );
  });

  group('isDonor', () {
    test(
      'deve retornar true se houver um usuário autenticado e for um doador.',
      () {
        // act
        controller.currentUser = tAuthorizedDonorUser;
        final result = controller.isDonor;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se houver um usuário autenticado e não for um doador.',
      () {
        // act
        controller.currentUser = tDeniedUser;
        final result = controller.isDonor;
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isDonor;
        // assert
        expect(result, false);
      },
    );
  });

  group('isBeneficiary', () {
    test(
      'deve retornar true se houver um usuário autenticado e for um beneficiário.',
      () {
        // act
        controller.currentUser = tAuthorizedBeneficiaryUser;
        final result = controller.isBeneficiary;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se houver um usuário autenticado e não for um beneficiário.',
      () {
        // act
        controller.currentUser = tDeniedUser;
        final result = controller.isBeneficiary;
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isBeneficiary;
        // assert
        expect(result, false);
      },
    );
  });

  group('isAuthorized', () {
    test(
      'deve retornar true se houver um usuário autenticado e estiver autorizado.',
      () {
        // act
        controller.currentUser = tAuthorizedDonorUser;
        final result = controller.isAuthorized;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se houver um usuário autenticado e não estiver autorizado.',
      () {
        // act
        controller.currentUser = tDeniedUser;
        final result = controller.isAuthorized;
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isAuthorized;
        // assert
        expect(result, false);
      },
    );
  });

  group('isDenied', () {
    test(
      'deve retornar true se houver um usuário autenticado e não estiver autorizado.',
      () {
        // act
        controller.currentUser = tDeniedUser;
        final result = controller.isDenied;
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false se houver um usuário autenticado e estiver autorizado.',
      () {
        // act
        controller.currentUser = tAuthorizedDonorUser;
        final result = controller.isDenied;
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false se não houver um usuário autenticado.',
      () {
        // act
        controller.currentUser = null;
        final result = controller.isDenied;
        // assert
        expect(result, false);
      },
    );
  });

  group('fetchCurrentUser', () {
    test(
      'deve setar o usuário quando ele estiver logado.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer((_) async => tAuthorizedDonorUser);
        // act
        await controller.fetchCurrentUser();
        // assert
        expect(controller.currentUser, tAuthorizedDonorUser);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve setar o usuário como null quando ele estiver deslogado.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer((_) async => null);
        // act
        await controller.fetchCurrentUser();
        // assert
        expect(controller.currentUser, null);
        expect(controller.isLoading, false);
      },
    );
  });

  group('login', () {
    test(
      'deve chamar a usecase para efetuar o login.',
      () async {
        // arrange
        when(() => doLoginMock(any(), any()))
            .thenAnswer((_) async => tDeniedUser);
        // act
        await controller.login('email', 'password');
        // assert
        verify(() => doLoginMock('email', 'password')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve chamar a função onSuccess ao efetuar o login com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => doLoginMock(any(), any()))
            .thenAnswer((_) async => tDeniedUser);
        // act
        await controller.login('email', 'password', onSuccess: onSuccess);
        // assert
        verify(onSuccess).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve deixar de chamar a função onSuccess ao não efetuar o login com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => doLoginMock(any(), any())).thenAnswer((_) async => null);
        // act
        await controller.login('email', 'password', onSuccess: onSuccess);
        // assert
        verifyNever(onSuccess);
        expect(controller.isLoading, false);
      },
    );
  });

  group('register', () {
    test(
      'deve chamar a usecase para efetuar o cadastro.',
      () async {
        // arrange
        when(() => doRegisterMock(any(), any(), tDeniedUser))
            .thenAnswer((_) async => tDeniedUser);
        // act
        await controller.register('email', 'password', tDeniedUser);
        // assert
        verify(() => doRegisterMock('email', 'password', tDeniedUser))
            .called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve chamar a função onSuccess ao efetuar o cadastro com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => doRegisterMock(any(), any(), tDeniedUser))
            .thenAnswer((_) async => tDeniedUser);
        // act
        await controller.register(
          'email',
          'password',
          tDeniedUser,
          onSuccess: onSuccess,
        );
        // assert
        verify(onSuccess).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve deixar de chamar a função onSuccess ao não efetuar o cadastro com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => doRegisterMock(any(), any(), tDeniedUser))
            .thenAnswer((_) async => null);
        // act
        await controller.register(
          'email',
          'password',
          tDeniedUser,
          onSuccess: onSuccess,
        );
        // assert
        verifyNever(onSuccess);
        expect(controller.isLoading, false);
      },
    );
  });

  group('sendPasswordResetEmail', () {
    test(
      'deve chamar a usecase para efetuar o envio do link de redefinição de senha.',
      () async {
        // arrange
        when(() => sendPasswordResetEmailMock(any()))
            .thenAnswer((_) async => true);
        // act
        await controller.sendPasswordResetEmail('email');
        // assert
        verify(() => sendPasswordResetEmailMock('email')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve chamar a função onSuccess ao efetuar o envio do link de redefinição de senha com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => sendPasswordResetEmailMock(any()))
            .thenAnswer((_) async => true);
        // act
        await controller.sendPasswordResetEmail('email', onSuccess: onSuccess);
        // assert
        verify(onSuccess).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve deixar de chamar a função onSuccess ao não efetuar o envio do link de redefinição de senha com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(() => sendPasswordResetEmailMock(any()))
            .thenAnswer((_) async => false);
        // act
        await controller.sendPasswordResetEmail('email', onSuccess: onSuccess);
        // assert
        verifyNever(onSuccess);
        expect(controller.isLoading, false);
      },
    );
  });

  group('logout', () {
    test(
      'deve chamar a usecase para efetuar o logout.',
      () async {
        // arrange
        when(doLogoutMock).thenAnswer((_) async => true);
        // act
        await controller.logout();
        // assert
        verify(doLogoutMock).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve chamar a função onSuccess ao efetuar o logout com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(doLogoutMock).thenAnswer((_) async => true);
        // act
        await controller.logout(onSuccess: onSuccess);
        // assert
        verify(onSuccess).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve deixar de chamar a função onSuccess ao não efetuar o logout com sucesso.',
      () async {
        // arrange
        final onSuccess = MockCallable<void>();
        when(doLogoutMock).thenAnswer((_) async => false);
        // act
        await controller.logout(onSuccess: onSuccess);
        // assert
        verifyNever(onSuccess);
        expect(controller.isLoading, false);
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = controller.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
