// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/data/dtos/firebase_dto.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  late DocumentSnapshot documentSnapshotMock;

  setUp(() {
    documentSnapshotMock = MockDocumentSnapshot();
  });

  group('toMap', () {
    test(
      'deve retornar um map com os atributos do snapshot.',
      () {
        // arrange
        when(() => documentSnapshotMock.id).thenAnswer((_) => 'test');
        when(() => documentSnapshotMock.data()).thenAnswer((_) => {'test': 1});
        // act
        final result = documentSnapshotMock.toMap();
        // assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 'test');
        expect(result['test'], 1);
      },
    );
  });
}
