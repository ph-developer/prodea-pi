import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/themes/main_theme.dart';

void main() {
  group('themeData', () {
    test(
      'deve ser do tipo ThemeData.',
      () {
        // assert
        expect(themeData, isA<ThemeData>());
      },
    );
  });
}
