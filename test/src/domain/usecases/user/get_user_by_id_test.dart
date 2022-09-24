import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/user/get_user_by_id.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IUserRepo userRepoMock;
  late GetUserById usecase;

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
    status: AuthorizationStatus.authorized,
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    userRepoMock = MockUserRepo();
    usecase = GetUserById(userRepoMock, notificationServiceMock);
  });

  test(
    'deve retornar o usuário quando houver um usuário com o id informado.',
    () async {
      // arrange
      when(() => userRepoMock.getById('id')).thenAnswer((_) async => tUser);
      // act
      final result = await usecase('id');
      // assert
      expect(result, isA<User>());
      expect(result, tUser);
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve retornar null e notificar quando não houver um usuário com o id informado.',
    () async {
      // arrange
      when(() => userRepoMock.getById('id')).thenThrow(GetUserFailure());
      // act
      final result = await usecase('id');
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
