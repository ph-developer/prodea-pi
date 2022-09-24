import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_denied.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IUserRepo userRepoMock;
  late SetUserAsDenied usecase;

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
    status: AuthorizationStatus.waiting,
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
    isDonor: true,
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.denied,
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    userRepoMock = MockUserRepo();
    usecase = SetUserAsDenied(userRepoMock, notificationServiceMock);
  });

  test(
    'deve retornar o usuário negado quando obtiver sucesso.',
    () async {
      // arrange
      when(() => userRepoMock.update(tDeniedUser))
          .thenAnswer((_) async => tDeniedUser);
      // act
      final result = await usecase(tUser);
      // assert
      expect(result, isA<User>());
      expect(result, tDeniedUser);
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve retornar null e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(() => userRepoMock.update(tDeniedUser))
          .thenThrow(UpdateUserFailure());
      // act
      final result = await usecase(tUser);
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
