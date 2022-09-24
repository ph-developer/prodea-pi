import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_canceled.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockDonationRepo extends Mock implements IDonationRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IDonationRepo donationRepoMock;
  late SetDonationAsCanceled usecase;

  final tDateNow = DateTime.now();
  const tReason = 'cancellation';
  final tDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    createdAt: tDateNow,
  );
  final tDonationCanceled = Donation(
    description: 'description',
    expiration: '01/01/5000',
    cancellation: tReason,
    isDelivered: false,
    createdAt: tDateNow,
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    donationRepoMock = MockDonationRepo();
    usecase = SetDonationAsCanceled(donationRepoMock, notificationServiceMock);
  });

  test(
    'deve retornar a doação cancelada quando obtiver sucesso.',
    () async {
      // arrange
      when(() => donationRepoMock.update(tDonationCanceled))
          .thenAnswer((_) async => tDonationCanceled);
      // act
      final result = await usecase(tDonation, tReason);
      // assert
      expect(result, tDonationCanceled);
    },
  );

  test(
    'deve retornar null e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(() => donationRepoMock.update(tDonationCanceled))
          .thenThrow(UpdateDonationFailure());
      // act
      final result = await usecase(tDonation, tReason);
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
