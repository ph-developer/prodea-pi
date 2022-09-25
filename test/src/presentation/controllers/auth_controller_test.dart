import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/usecases/auth/do_login.dart';
import 'package:prodea/src/domain/usecases/auth/do_logout.dart';
import 'package:prodea/src/domain/usecases/auth/do_register.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';
import 'package:prodea/src/domain/usecases/auth/send_password_reset_email.dart';
import 'package:prodea/src/presentation/controllers/auth_controller.dart';

class MockModularNavigator extends Mock implements IModularNavigator {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockDoLogin extends Mock implements DoLogin {}

class MockDoRegister extends Mock implements DoRegister {}

class MockDoLogout extends Mock implements DoLogout {}

class MockSendPasswordResetEmail extends Mock
    implements SendPasswordResetEmail {}

void main() {
  late IModularNavigator modularNavigatorMock;
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

  const tWaitingUser = User(
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
    status: AuthorizationStatus.waiting,
  );

  setUp(() {
    modularNavigatorMock = MockModularNavigator();
    getCurrentUserMock = MockGetCurrentUser();
    doLoginMock = MockDoLogin();
    doRegisterMock = MockDoRegister();
    doLogoutMock = MockDoLogout();
    sendPasswordResetEmailMock = MockSendPasswordResetEmail();

    when(getCurrentUserMock).thenAnswer((_) => const Stream<User?>.empty());

    controller = AuthController(
      getCurrentUserMock,
      doLoginMock,
      doRegisterMock,
      doLogoutMock,
      sendPasswordResetEmailMock,
    );

    Modular.navigatorDelegate = modularNavigatorMock;
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

  group('isReady', () {
    test(
      'deve retornar true após a primeira emissão do usuário atual.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer((_) => Stream.fromIterable([null]));
        // act
        final result = await controller.isReady();
        // assert
        expect(result, equals(true));
      },
    );
  });

  group('init', () {
    test(
      'deve inicializar o controller e navegar para a página "doar" quando o '
      'usuário estiver logado e for um doador.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tAuthorizedDonorUser]));
        // act
        controller.init();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/main/donate')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve inicializar o controller e navegar para a página "doações '
      'disponíveis" quando o usuário estiver logado e for um beneficiário.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer(
            (_) => Stream.fromIterable([tAuthorizedBeneficiaryUser]));
        // act
        controller.init();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/main/available-donations'))
            .called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve inicializar o controller e navegar para a página "negado" quando o '
      'usuário estiver logado e seu cadastro ter sido negado.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tDeniedUser]));
        // act
        controller.init();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/denied')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve inicializar o controller e navegar para a página "aguardando" '
      'quando o usuário estiver logado e seu cadastro estar em análise.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tWaitingUser]));
        // act
        controller.init();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/waiting')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve inicializar o controller e navegar para a página "login" quando o '
      'usuário não estiver logado.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer((_) => Stream.fromIterable([null]));
        // act
        controller.init();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/login')).called(1);
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
  });

  group('sendPasswordResetEmail', () {
    test(
      'deve chamar a usecase para efetuar o envio do link de redefinição de '
      'senha e navegar para a página de login se obtiver sucesso.',
      () async {
        // arrange
        when(() => sendPasswordResetEmailMock(any()))
            .thenAnswer((_) async => true);
        // act
        await controller.sendPasswordResetEmail('email');
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => sendPasswordResetEmailMock('email')).called(1);
        verify(() => modularNavigatorMock.navigate('/login')).called(1);
        expect(controller.isLoading, false);
      },
    );

    test(
      'deve chamar a usecase para efetuar o envio do link de redefinição de '
      'senha e manter-se na página se não obtiver sucesso.',
      () async {
        // arrange
        when(() => sendPasswordResetEmailMock(any()))
            .thenAnswer((_) async => false);
        // act
        await controller.sendPasswordResetEmail('email');
        // assert
        verify(() => sendPasswordResetEmailMock('email')).called(1);
        verifyNever(() => modularNavigatorMock.navigate(any()));
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
  });

  group('navigateToLoginPage', () {
    test(
      'deve navegar para a página de login.',
      () async {
        // act
        controller.navigateToLoginPage();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/login')).called(1);
      },
    );
  });

  group('navigateToForgotPasswordPage', () {
    test(
      'deve navegar para a página de solicitação de link de redefinição de senha.',
      () async {
        // act
        controller.navigateToForgotPasswordPage();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/forgot')).called(1);
      },
    );
  });

  group('navigateToRegisterPage', () {
    test(
      'deve navegar para a página de cadastro.',
      () async {
        // act
        controller.navigateToRegisterPage();
        await untilCalled(() => modularNavigatorMock.navigate(any()));
        // assert
        verify(() => modularNavigatorMock.navigate('/register')).called(1);
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
