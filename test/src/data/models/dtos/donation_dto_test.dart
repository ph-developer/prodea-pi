import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/dtos/donation_dto.dart';
import 'package:prodea/src/domain/entities/donation.dart';

void main() {
  const tModel = Donation(
    description: 'description',
    expiration: '01/01/2000',
    beneficiaryId: 'beneficiaryId',
    isDelivered: false,
    createdAt: null,
  );

  final tMapWithTimestampCreatedAt = {
    'description': 'description',
    'photoUrl': null,
    'donorId': null,
    'beneficiaryId': 'beneficiaryId',
    'expiration': '01/01/2000',
    'cancellation': null,
    'isDelivered': false,
    'createdAt': Timestamp.fromDate(DateTime.now()),
  };

  final tMapWithDateTimeCreatedAt = {
    'description': 'description',
    'photoUrl': null,
    'donorId': null,
    'beneficiaryId': 'beneficiaryId',
    'expiration': '01/01/2000',
    'cancellation': null,
    'isDelivered': false,
    'createdAt': DateTime.now(),
  };

  group('toMap', () {
    test(
      'deve retornar um map com os atributos do model.',
      () {
        // act
        final result = tModel.toMap();
        // assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['description'], tModel.description);
        expect(result['beneficiaryId'], tModel.beneficiaryId);
      },
    );
  });

  group('fromMap', () {
    test(
      'deve retornar um model com os atributos do map (timestamp created at).',
      () {
        // act
        final result = DonationDTO.fromMap(tMapWithTimestampCreatedAt);
        // assert
        expect(result, isA<Donation>());
        expect(result.description, tMapWithTimestampCreatedAt['description']);
        expect(
            result.beneficiaryId, tMapWithTimestampCreatedAt['beneficiaryId']);
        expect(result.createdAt, isA<DateTime>());
      },
    );

    test(
      'deve retornar um model com os atributos do map (datetime created at).',
      () {
        // act
        final result = DonationDTO.fromMap(tMapWithDateTimeCreatedAt);
        // assert
        expect(result, isA<Donation>());
        expect(result.description, tMapWithDateTimeCreatedAt['description']);
        expect(
            result.beneficiaryId, tMapWithDateTimeCreatedAt['beneficiaryId']);
        expect(result.createdAt, isA<DateTime>());
      },
    );
  });
}
