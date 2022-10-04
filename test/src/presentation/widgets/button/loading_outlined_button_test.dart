import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/button/loading_outlined_button.dart';

import '../../../../mocks/widgets.dart';

void main() {
  testWidgets('deve testar o botão de loading', (tester) async {
    // arrange
    Finder widget;
    await tester.pumpWidget(makeWidgetTestable(
      const LoadingOutlinedButton(),
    ));

    // assert
    expect(find.byType(LoadingOutlinedButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    widget = find.byType(OutlinedButton).at(0);
    expect(tester.widget<OutlinedButton>(widget).enabled, isFalse);
  });
}
