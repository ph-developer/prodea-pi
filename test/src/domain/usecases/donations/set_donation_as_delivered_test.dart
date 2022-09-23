import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_delivered.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockDonationRepo extends Mock implements IDonationRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IDonationRepo donationRepoMock;
  late SetDonationAsDelivered usecase;

  final tDateNow = DateTime.now();
  final tDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    createdAt: tDateNow,
  );
  final tDonationDelivered = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: true,
    createdAt: tDateNow,
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    donationRepoMock = MockDonationRepo();
    usecase = SetDonationAsDelivered(donationRepoMock, notificationServiceMock);
  });

  test('deve retornar a doação entregue quando obtiver sucesso.', () async {
    // arrange
    when(() => donationRepoMock.update(tDonationDelivered))
        .thenAnswer((_) async => tDonationDelivered);
    // act
    final result = await usecase(tDonation);
    // assert
    expect(result, tDonationDelivered);
  });

  test('deve retornar null e notificar quando algum erro ocorrer.', () async {
    // arrange
    when(() => donationRepoMock.update(tDonationDelivered))
        .thenThrow(UpdateDonationFailure());
    // act
    final result = await usecase(tDonation);
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
