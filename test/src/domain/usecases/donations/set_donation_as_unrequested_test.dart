import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_unrequested.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockDonationRepo extends Mock implements IDonationRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IDonationRepo donationRepoMock;
  late SetDonationAsUnrequested usecase;

  final tDateNow = DateTime.now();
  final tDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    beneficiaryId: 'beneficiaryId',
    createdAt: tDateNow,
  );
  final tDonationUnrequested = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    beneficiaryId: null,
    createdAt: tDateNow,
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    donationRepoMock = MockDonationRepo();
    usecase =
        SetDonationAsUnrequested(donationRepoMock, notificationServiceMock);
  });

  test('deve retornar a doação como não solicitada quando obtiver sucesso.',
      () async {
    // arrange
    when(() => donationRepoMock.update(tDonationUnrequested))
        .thenAnswer((_) async => tDonationUnrequested);
    // act
    final result = await usecase(tDonation);
    // assert
    expect(result, tDonationUnrequested);
  });

  test('deve retornar null e notificar quando algum erro ocorrer.', () async {
    // arrange
    when(() => donationRepoMock.update(tDonationUnrequested))
        .thenThrow(UpdateDonationFailure());
    // act
    final result = await usecase(tDonation);
    // assert
    expect(result, null);
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
