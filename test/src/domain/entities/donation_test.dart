import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/entities/donation.dart';

void main() {
  final tDateTimeNow = DateTime.now();
  final tModel = Donation(
    description: 'description',
    expiration: 'expiration',
    isDelivered: false,
    createdAt: tDateTimeNow,
  );

  test('deve retornar true quando os atributos forem iguais.', () {
    // arrange
    final tOtherModel = Donation(
      description: 'description',
      expiration: 'expiration',
      isDelivered: false,
      createdAt: tDateTimeNow,
    );
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, true);
  });

  test('deve retornar false quando ao menos um dos atributos for diferente.',
      () {
    // arrange
    final tOtherModel = Donation(
      description: 'other_description',
      expiration: 'expiration',
      isDelivered: false,
      createdAt: tDateTimeNow,
    );
    // act
    final result = tModel == tOtherModel;
    // assert
    expect(result, false);
  });
}
