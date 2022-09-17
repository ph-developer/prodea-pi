import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/core/extensions/date_time.dart';

void main() {
  group('toDateStr', () {
    test('deve retornar a data no formato dia/mês/ano.', () {
      // arrange
      final tDate = DateTime(2022, 1, 1);
      // act
      final result = tDate.toDateStr();
      // assert
      expect(result, '1/1/2022');
    });
  });
}
