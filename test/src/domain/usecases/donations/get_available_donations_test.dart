import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/usecases/donations/get_available_donations.dart';

class MockDonationRepo extends Mock implements IDonationRepo {}

void main() {
  late IDonationRepo donationRepoMock;
  late GetAvailableDonations usecase;

  final tDonationOk = Donation(
    description: 'description',
    expiration: '01/01/5000',
    beneficiaryId: null,
    cancellation: null,
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationWrong1 = Donation(
    description: 'description',
    expiration: '01/01/5000',
    beneficiaryId: 'beneficiaryId',
    cancellation: null,
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationWrong2 = Donation(
    description: 'description',
    expiration: '01/01/5000',
    beneficiaryId: null,
    cancellation: 'cancellation',
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationWrong3 = Donation(
    description: 'description',
    expiration: '01/01/2022',
    beneficiaryId: null,
    cancellation: null,
    isDelivered: false,
    createdAt: DateTime.now(),
  );

  setUp(() {
    donationRepoMock = MockDonationRepo();
    usecase = GetAvailableDonations(donationRepoMock);
  });

  test(
    'deve emitir uma lista de doações que não estão canceladas, expiradas ou com beneficiário definido.',
    () {
      // arrange
      when(donationRepoMock.getDonations)
          .thenAnswer((_) => Stream.fromIterable([
                [tDonationOk, tDonationWrong1, tDonationWrong2, tDonationWrong3]
              ]));
      // act
      final stream = usecase();
      // assert
      expect(stream, emits(isA<List<Donation>>()));
      expect(stream, emits([tDonationOk]));
    },
  );
}
