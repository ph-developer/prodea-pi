import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/auth/do_register.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IAuthRepo authRepoMock;
  late IUserRepo userRepoMock;
  late DoRegister usecase;

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
    usecase = DoRegister(authRepoMock, userRepoMock, notificationServiceMock);

    registerFallbackValue(tUser);
  });

  test('deve retornar um User quando o registro for bem sucedido.', () async {
    // arrange
    when(() => authRepoMock.register(any(), any()))
        .thenAnswer((_) async => 'id');
    when(() => userRepoMock.create(any())).thenAnswer((_) async => tUser);
    // act
    final result = await usecase('test@test.dev', 'test', tUser);
    // assert
    expect(result, tUser);
    verifyNever(() => notificationServiceMock.notifyError(any()));
  });

  test(
      'deve retornar null e notificar um erro quando o email estiver em branco.',
      () async {
    // act
    final result = await usecase('', 'test', tUser);
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });

  test(
      'deve retornar null e notificar um erro quando a senha estiver em branco.',
      () async {
    // act
    final result = await usecase('test@test.dev', '', tUser);
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });

  test('deve retornar null e notificar um erro quando ocorrer algum erro.',
      () async {
    // arrange
    when(() => authRepoMock.register(any(), any()))
        .thenThrow(RegisterFailure());
    // act
    final result = await usecase('test@test.dev', 'test', tUser);
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
