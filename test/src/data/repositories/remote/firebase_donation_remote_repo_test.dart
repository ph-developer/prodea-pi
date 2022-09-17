// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/repositories/remote/firebase_donation_remote_repo.dart';
import 'package:prodea/src/domain/entities/donation.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late FirebaseFirestore firestoreFake;
  late FirebaseDonationRemoteRepo firebaseDonationRemoteRepoWithFake;
  late FirebaseFirestore firestoreMock;
  late FirebaseDonationRemoteRepo firebaseDonationRemoteRepoWithMock;

  final tDonation = Donation(
    id: 'id',
    description: 'test',
    expiration: '01/01/2022',
    isDelivered: false,
    createdAt: DateTime.now(),
  );

  final tDonationMap = {
    'description': 'description',
    'photoUrl': null,
    'donorId': null,
    'beneficiaryId': 'beneficiaryId',
    'expiration': '01/01/2000',
    'cancellation': null,
    'isDelivered': false,
    'createdAt': DateTime.now(),
  };

  setUp(() {
    firestoreFake = FakeFirebaseFirestore();
    firebaseDonationRemoteRepoWithFake =
        FirebaseDonationRemoteRepo(firestoreFake);
    firestoreMock = MockFirebaseFirestore();
    firebaseDonationRemoteRepoWithMock =
        FirebaseDonationRemoteRepo(firestoreMock);
  });

  group('create', () {
    test('deve retornar uma Donation quando obtiver sucesso na criação.',
        () async {
      // act
      final result = await firebaseDonationRemoteRepoWithFake.create(tDonation);
      // assert
      expect(result, isA<Donation>());
      expect(result.id, isA<String>());
      expect(result.description, tDonation.description);
      expect(result.createdAt, tDonation.createdAt);
    });

    test('deve disparar uma CreateDonationFailure quando ocorrer algum erro.',
        () {
      // arrange
      when(() => firestoreMock.collection(any())).thenThrow(Exception());
      // act
      final result = firebaseDonationRemoteRepoWithMock.create(tDonation);
      // assert
      expect(result, throwsA(isA<CreateDonationFailure>()));
    });
  });

  group('update', () {
    test('deve retornar uma Donation quando obtiver sucesso na alteração.',
        () async {
      // act
      final result = await firebaseDonationRemoteRepoWithFake.update(tDonation);
      // assert
      expect(result, isA<Donation>());
      expect(result.id, tDonation.id);
      expect(result.description, tDonation.description);
      expect(result.createdAt, tDonation.createdAt);
    });

    test('deve disparar uma UpdateDonationFailure quando ocorrer algum erro.',
        () {
      // arrange
      when(() => firestoreMock.collection(any())).thenThrow(Exception());
      // act
      final result = firebaseDonationRemoteRepoWithMock.update(tDonation);
      // assert
      expect(result, throwsA(isA<UpdateDonationFailure>()));
    });
  });

  group('getDonations', () {
    test('deve retornar uma lista de doações.', () async {
      // arrange
      firestoreFake.collection('donation').add(tDonationMap);
      // act
      final stream = firebaseDonationRemoteRepoWithFake.getDonations();
      // assert
      expect(stream, emits(isA<List<Donation>>()));
    });
  });
}
