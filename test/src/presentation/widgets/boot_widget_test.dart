import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/boot_widget.dart';

void main() {
  testWidgets('deve testar a tela de boot', (tester) async {
    // arrange
    await tester.pumpWidget(const BootWidget());

    // assert
    expect(find.byType(BootWidget), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
