import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/button/loading_outlined_button.dart';

void main() {
  testWidgets('deve testar o botão', (tester) async {
    // arrange
    await tester.pumpWidget(const LoadingOutlinedButton());

    // assert
    expect(find.byType(LoadingOutlinedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
