import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_requested.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IAuthRepo authRepoMock;
  late INotificationService notificationServiceMock;
  late IDonationRepo donationRepoMock;
  late SetDonationAsRequested usecase;

  final tDateNow = DateTime.now();
  const tBeneficiaryId = 'beneficiaryId';
  final tDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    beneficiaryId: null,
    createdAt: tDateNow,
  );
  final tDonationRequested = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    beneficiaryId: tBeneficiaryId,
    createdAt: tDateNow,
  );

  setUp(() {
    authRepoMock = MockAuthRepo();
    notificationServiceMock = MockNotificationService();
    donationRepoMock = MockDonationRepo();
    usecase = SetDonationAsRequested(
      authRepoMock,
      donationRepoMock,
      notificationServiceMock,
    );
  });

  test(
    'deve retornar a doação como solicitada quando obtiver sucesso.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId)
          .thenAnswer((_) async => tBeneficiaryId);
      when(() => donationRepoMock.update(tDonationRequested))
          .thenAnswer((_) async => tDonationRequested);
      // act
      final result = await usecase(tDonation);
      // assert
      expect(result, tDonationRequested);
    },
  );

  test(
    'deve retornar null e notificar quando o usuário não estiver autenticado.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId).thenAnswer((_) async => null);
      // act
      final result = await usecase(tDonation);
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );

  test(
    'deve retornar null e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(authRepoMock.getCurrentUserId)
          .thenAnswer((_) async => tBeneficiaryId);
      when(() => donationRepoMock.update(tDonationRequested))
          .thenThrow(UpdateDonationFailure());
      // act
      final result = await usecase(tDonation);
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
