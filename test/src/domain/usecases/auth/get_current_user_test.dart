import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

class MockNotificationService extends Mock implements INotificationService {}

void main() {
  late INotificationService notificationServiceMock;
  late IAuthRepo authRepoMock;
  late IUserRepo userRepoMock;
  late GetCurrentUser usecase;

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
    usecase = GetCurrentUser(
      authRepoMock,
      userRepoMock,
      notificationServiceMock,
    );
  });

  test(
    'deve retornar um User quando o usuário estiver logado.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId).thenAnswer((_) async => 'id');
      when(() => userRepoMock.getById('id')).thenAnswer((_) async => tUser);
      // act
      final result = await usecase();
      // assert
      expect(result, tUser);
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve retornar null quando o usuário estiver deslogado.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId).thenAnswer((_) async => null);
      // act
      final result = await usecase();
      // assert
      expect(result, null);
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve retornar null e notificar quando ocorrer algum erro.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId).thenAnswer((_) async => 'id');
      when(() => userRepoMock.getById(any())).thenThrow(GetUserFailure());
      // act
      final result = await usecase();
      // assert
      expect(result, null);
      await untilCalled(() => notificationServiceMock.notifyError(any()));
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
