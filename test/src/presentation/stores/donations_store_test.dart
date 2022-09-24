import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/usecases/donations/get_available_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_donation_photo_url.dart';
import 'package:prodea/src/domain/usecases/donations/get_my_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_requested_donations.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_canceled.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_delivered.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_requested.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_unrequested.dart';
import 'package:prodea/src/presentation/stores/donations_store.dart';

import '../mobx_helpers.dart';

class MockGetRequestedDonations extends Mock implements GetRequestedDonations {}

class MockGetAvailableDonations extends Mock implements GetAvailableDonations {}

class MockGetMyDonations extends Mock implements GetMyDonations {}

class MockSetDonationAsDelivered extends Mock
    implements SetDonationAsDelivered {}

class MockSetDonationAsRequested extends Mock
    implements SetDonationAsRequested {}

class MockSetDonationAsUnrequested extends Mock
    implements SetDonationAsUnrequested {}

class MockSetDonationAsCanceled extends Mock implements SetDonationAsCanceled {}

class MockGetDonationPhotoUrl extends Mock implements GetDonationPhotoUrl {}

void main() {
  late GetRequestedDonations getRequestedDonationsMock;
  late GetAvailableDonations getAvailableDonationsMock;
  late GetMyDonations getMyDonationsMock;
  late SetDonationAsDelivered setDonationAsDeliveredMock;
  late SetDonationAsRequested setDonationAsRequestedMock;
  late SetDonationAsUnrequested setDonationAsUnrequestedMock;
  late SetDonationAsCanceled setDonationAsCanceledMock;
  late GetDonationPhotoUrl getDonationPhotoUrlMock;
  late DonationsStore store;

  final tDonationWithPhoto = Donation(
    description: 'description',
    expiration: '01/01/5000',
    photoUrl: 'photoUrl',
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationWithoutPhoto = Donation(
    description: 'description',
    expiration: '01/01/5000',
    photoUrl: null,
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tDonationList = [tDonationWithPhoto, tDonationWithoutPhoto];

  setUp(() {
    getRequestedDonationsMock = MockGetRequestedDonations();
    getAvailableDonationsMock = MockGetAvailableDonations();
    getMyDonationsMock = MockGetMyDonations();
    setDonationAsDeliveredMock = MockSetDonationAsDelivered();
    setDonationAsRequestedMock = MockSetDonationAsRequested();
    setDonationAsUnrequestedMock = MockSetDonationAsUnrequested();
    setDonationAsCanceledMock = MockSetDonationAsCanceled();
    getDonationPhotoUrlMock = MockGetDonationPhotoUrl();
    store = DonationsStore(
      getRequestedDonationsMock,
      getAvailableDonationsMock,
      getMyDonationsMock,
      setDonationAsDeliveredMock,
      setDonationAsRequestedMock,
      setDonationAsUnrequestedMock,
      setDonationAsCanceledMock,
      getDonationPhotoUrlMock,
    );
  });

  test('deve inicializar a store, populando as listas de doações.', () async {
    // arrange
    when(getRequestedDonationsMock)
        .thenAnswer((_) => Stream.fromIterable([tDonationList]));
    when(getAvailableDonationsMock)
        .thenAnswer((_) => Stream.fromIterable([tDonationList]));
    when(getMyDonationsMock)
        .thenAnswer((_) => Stream.fromIterable([tDonationList]));
    final requestedDonationsChanged = MockCallable<List<Donation>>();
    final availableDonationsChanged = MockCallable<List<Donation>>();
    final myDonationsChanged = MockCallable<List<Donation>>();
    whenReaction((_) => store.requestedDonations, requestedDonationsChanged);
    whenReaction((_) => store.availableDonations, availableDonationsChanged);
    whenReaction((_) => store.myDonations, myDonationsChanged);
    // assert
    expect(store.requestedDonations, equals([]));
    expect(store.availableDonations, equals([]));
    expect(store.myDonations, equals([]));
    // act
    store.init();
    await untilCalled(() => requestedDonationsChanged(tDonationList));
    await untilCalled(() => availableDonationsChanged(tDonationList));
    await untilCalled(() => myDonationsChanged(tDonationList));
    // assert
    expect(store.requestedDonations, tDonationList);
    expect(store.availableDonations, tDonationList);
    expect(store.myDonations, tDonationList);
  });

  test('deve retornar o url da foto da doação caso ela tenha.', () async {
    // arrange
    when(() => getDonationPhotoUrlMock(tDonationWithPhoto))
        .thenAnswer((_) async => 'photo');
    // act
    final result = await store.getDonationPhotoURL(tDonationWithPhoto);
    // assert
    expect(result, 'photo');
  });

  test('deve retornar null caso a doação não tenha foto.', () async {
    // arrange
    when(() => getDonationPhotoUrlMock(tDonationWithoutPhoto))
        .thenAnswer((_) async => null);
    // act
    final result = await store.getDonationPhotoURL(tDonationWithoutPhoto);
    // assert
    expect(result, null);
  });

  test('deve chamar a usecase para marcar a doação como entregue.', () async {
    // arrange
    when(() => setDonationAsDeliveredMock(tDonationWithPhoto))
        .thenAnswer((_) async => tDonationWithPhoto);
    // act
    await store.setDonationAsDelivered(tDonationWithPhoto);
    // assert
    verify(() => setDonationAsDeliveredMock(tDonationWithPhoto)).called(1);
  });

  test('deve chamar a usecase para marcar a doação como solicitada.', () async {
    // arrange
    when(() => setDonationAsRequestedMock(tDonationWithPhoto))
        .thenAnswer((_) async => tDonationWithPhoto);
    // act
    await store.setDonationAsRequested(tDonationWithPhoto);
    // assert
    verify(() => setDonationAsRequestedMock(tDonationWithPhoto)).called(1);
  });

  test('deve chamar a usecase para marcar a doação como não solicitada.',
      () async {
    // arrange
    when(() => setDonationAsUnrequestedMock(tDonationWithPhoto))
        .thenAnswer((_) async => tDonationWithPhoto);
    // act
    await store.setDonationAsUnrequested(tDonationWithPhoto);
    // assert
    verify(() => setDonationAsUnrequestedMock(tDonationWithPhoto)).called(1);
  });

  test('deve chamar a usecase para marcar a doação como cancelada.', () async {
    // arrange
    when(() => setDonationAsCanceledMock(tDonationWithPhoto, 'reason'))
        .thenAnswer((_) async => tDonationWithPhoto);
    // act
    await store.setDonationAsCanceled(tDonationWithPhoto, 'reason');
    // assert
    verify(() => setDonationAsCanceledMock(tDonationWithPhoto, 'reason'))
        .called(1);
  });

  test('deve retornar uma string.', () {
    // act
    final result = store.toString();
    // assert
    expect(result, isA<String>());
  });
}
