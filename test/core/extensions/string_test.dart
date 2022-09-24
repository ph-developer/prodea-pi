import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/core/extensions/string.dart';

void main() {
  group('includes', () {
    test(
      'deve retornar true quando a string incluir o valor pesquisado.',
      () {
        // arrange
        const tStr = 'abóbora';
        // act
        final result = tStr.includes('bobó');
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false quando a string não incluir o valor pesquisado.',
      () {
        // arrange
        const tStr = 'abóbora';
        // act
        final result = tStr.includes('ca');
        // assert
        expect(result, false);
      },
    );
  });

  group('isAValidDate', () {
    test(
      'deve retornar true quando a string for uma data válida.',
      () {
        // arrange
        const tStr = '1/1/2022';
        // act
        final result = tStr.isAValidDate();
        // assert
        expect(result, true);
      },
    );

    test(
      'deve retornar false quando a string não for uma data válida.',
      () {
        // arrange
        const tStr = 'not_a_date';
        // act
        final result = tStr.isAValidDate();
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false quando a string não possuir um dia válido.',
      () {
        // arrange
        const tStr = '32/1/2022';
        // act
        final result = tStr.isAValidDate();
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false quando a string não possuir um mês válido.',
      () {
        // arrange
        const tStr = '1/31/2022';
        // act
        final result = tStr.isAValidDate();
        // assert
        expect(result, false);
      },
    );

    test(
      'deve retornar false quando a string não possuir um ano válido.',
      () {
        // arrange
        const tStr = '1/1/1';
        // act
        final result = tStr.isAValidDate();
        // assert
        expect(result, false);
      },
    );
  });
}
