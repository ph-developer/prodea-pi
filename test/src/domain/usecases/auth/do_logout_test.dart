import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/auth/do_logout.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockAuthRepo extends Mock implements IAuthRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IAuthRepo authRepoMock;
  late DoLogout usecase;

  setUp(() {
    notificationServiceMock = MockNotificationService();
    authRepoMock = MockAuthRepo();
    usecase = DoLogout(authRepoMock, notificationServiceMock);
  });

  test('deve executar sem erros quando o logout for bem sucedido.', () async {
    // arrange
    when(() => authRepoMock.logout()).thenAnswer((_) async => true);
    // act
    final result = await usecase();
    // assert
    expect(result, true);
    verifyNever(() => notificationServiceMock.notifyError(any()));
  });

  test('deve retornar false e notificar um erro quando ocorrer algum erro.',
      () async {
    // arrange
    when(() => authRepoMock.logout()).thenThrow(LogoutFailure());
    // act
    final result = await usecase();
    // assert
    expect(result, false);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
