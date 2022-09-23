import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/usecases/donations/get_requested_donations.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockDonationRepo extends Mock implements IDonationRepo {}

void main() {
  late IAuthRepo authRepoMock;
  late IDonationRepo donationRepoMock;
  late GetRequestedDonations usecase;

  const tBeneficiaryId = 'beneficiaryId';
  final tDonationOk = Donation(
    description: 'description',
    expiration: '01/01/5000',
    beneficiaryId: tBeneficiaryId,
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationWrong = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    createdAt: DateTime.now(),
  );

  setUp(() {
    authRepoMock = MockAuthRepo();
    donationRepoMock = MockDonationRepo();
    usecase = GetRequestedDonations(authRepoMock, donationRepoMock);
  });

  test(
      'deve emitir uma lista de doações onde o beneficiário é o usuário autenticado.',
      () {
    // arrange
    when(authRepoMock.getCurrentUserId).thenAnswer((_) async => tBeneficiaryId);
    when(donationRepoMock.getDonations).thenAnswer((_) => Stream.fromIterable([
          [tDonationOk, tDonationWrong]
        ]));
    // act
    final stream = usecase();
    // assert
    expect(stream, emits(isA<List<Donation>>()));
    expect(stream, emits([tDonationOk]));
  });

  test('deve emitir uma lista vazia quando o usuário não estiver autenticado.',
      () {
    // arrange
    when(authRepoMock.getCurrentUserId).thenAnswer((_) async => null);
    when(donationRepoMock.getDonations).thenAnswer((_) => Stream.fromIterable([
          [tDonationOk, tDonationWrong]
        ]));
    // act
    final stream = usecase();
    // assert
    expect(stream, emits(isA<List<Donation>>()));
    expect(stream, emits([]));
  });
}
