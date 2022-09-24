import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/auth/send_password_reset_email.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockAuthRepo extends Mock implements IAuthRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IAuthRepo authRepoMock;
  late SendPasswordResetEmail usecase;

  setUp(() {
    notificationServiceMock = MockNotificationService();
    authRepoMock = MockAuthRepo();
    usecase = SendPasswordResetEmail(authRepoMock, notificationServiceMock);
  });

  test(
    'deve retornar true e notificar quando o email de redefinição de senha for enviado.',
    () async {
      // arrange
      when(() => authRepoMock.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase('test@test.dev');
      // assert
      expect(result, true);
      verify(() => notificationServiceMock.notifySuccess(any())).called(1);
      verifyNever(() => notificationServiceMock.notifyError(any()));
    },
  );

  test(
    'deve retornar false e notificar um erro quando o email estiver em branco.',
    () async {
      // act
      final result = await usecase('');
      // assert
      expect(result, false);
      verifyNever(() => notificationServiceMock.notifySuccess(any()));
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );

  test(
    'deve retornar false e notificar um erro quando ocorrer algum erro.',
    () async {
      // arrange
      when(() => authRepoMock.sendPasswordResetEmail(any()))
          .thenThrow(PasswordResetFailure());
      // act
      final result = await usecase('test@test.dev');
      // assert
      expect(result, false);
      verifyNever(() => notificationServiceMock.notifySuccess(any()));
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
