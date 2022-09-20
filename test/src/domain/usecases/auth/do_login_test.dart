import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/auth/do_login.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IAuthRepo authRepoMock;
  late IUserRepo userRepoMock;
  late DoLogin usecase;

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

  setUp(() {
    notificationServiceMock = MockNotificationService();
    authRepoMock = MockAuthRepo();
    userRepoMock = MockUserRepo();
    usecase = DoLogin(authRepoMock, notificationServiceMock, userRepoMock);
  });

  test('deve retornar um User quando o login for bem sucedido.', () async {
    // arrange
    when(() => authRepoMock.login(any(), any())).thenAnswer((_) async => 'id');
    when(() => userRepoMock.getById('id')).thenAnswer((_) async => tUser);
    // act
    final result = await usecase('test@test.dev', 'test');
    // assert
    expect(result, tUser);
    verifyNever(() => notificationServiceMock.notifyError(any()));
  });

  test(
      'deve retornar null e notificar um erro quando o email estiver em branco.',
      () async {
    // act
    final result = await usecase('', 'test');
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });

  test(
      'deve retornar null e notificar um erro quando a senha estiver em branco.',
      () async {
    // act
    final result = await usecase('test@test.dev', '');
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });

  test('deve retornar null e notificar um erro quando ocorrer algum erro.',
      () async {
    // arrange
    when(() => authRepoMock.login(any(), any())).thenThrow(LoginFailure());
    // act
    final result = await usecase('test@test.dev', 'test');
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
