import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/dtos/donation_dto.dart';
import 'package:prodea/src/domain/entities/donation.dart';

void main() {
  const tModel = Donation(
    description: 'description',
    expiration: '01/01/2000',
    beneficiaryId: 'beneficiaryId',
    isDelivered: false,
    createdAt: null,
  );

  group('copyWith', () {
    test('deve fazer uma cópia do model, alterando os atributos.', () {
      // act
      final result = tModel.copyWith(
        beneficiaryId: 'null',
      );
      // assert
      expect(result, isA<Donation>());
      expect(result.beneficiaryId, null);
      expect(result.description, tModel.description);
    });
  });

  group('isExpired', () {
    test('deve retornar que a doação está expirada.', () {
      // act
      final result = tModel.isExpired;
      // assert
      expect(result, true);
    });

    test('deve retornar que a doação não está expirada.', () {
      // arrange
      final model = tModel.copyWith(
        expiration: '01/01/5000',
      );
      // act
      final result = model.isExpired;
      // assert
      expect(result, false);
    });
  });

  group('status', () {
    test('deve retornar o status de cancelado.', () {
      // arrange
      final model = tModel.copyWith(
        cancellation: 'Teste',
      );
      // act
      final result = model.status;
      // assert
      expect(result, isA<String>());
      expect(result, 'Cancelada. Motivo: Teste');
    });

    test('deve retornar o status de entregue.', () {
      // arrange
      final model = tModel.copyWith(
        isDelivered: true,
      );
      // act
      final result = model.status;
      // assert
      expect(result, isA<String>());
      expect(result, 'Doação retirada ou entregue');
    });

    test('deve retornar o status de validade expirada.', () {
      // arrange
      final model = tModel.copyWith(
        expiration: '01/01/2000',
      );
      // act
      final result = model.status;
      // assert
      expect(result, isA<String>());
      expect(result, 'Validade expirada');
    });

    test('deve retornar o status de aguardando interessados.', () {
      // arrange
      final model = tModel.copyWith(
        expiration: '01/01/5000',
        beneficiaryId: 'null',
      );
      // act
      final result = model.status;
      // assert
      expect(result, isA<String>());
      expect(result, 'Aguardando interessados');
    });

    test('deve retornar o status de aguardando retirada.', () {
      // arrange
      final model = tModel.copyWith(
        expiration: '01/01/5000',
      );
      // act
      final result = model.status;
      // assert
      expect(result, isA<String>());
      expect(result, 'Aguardando retirada ou entrega');
    });
  });
}
