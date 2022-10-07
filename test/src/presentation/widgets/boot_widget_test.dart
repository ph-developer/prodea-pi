import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/boot_widget.dart';
import 'package:lottie/lottie.dart';

import '../../../mocks/mocks.dart';
import '../../../mocks/widgets.dart';

void main() {
  final widgetsBinding = TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('deve testar a tela de boot', (tester) async {
    // arrange
    Finder widget;
    await tester.pumpWidget(BootWidget(widgetsBinding: widgetsBinding));

    // assert
    expect(find.byType(BootWidget), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // pega as rotas existentes
    widget = find.byType(MaterialApp);
    final materialApp = tester.widget<MaterialApp>(widget);
    final routes = materialApp.routes!;
    final routePaths = routes.keys;

    // assert loop
    for (var path in routePaths) {
      // arrange
      final builder = routes[path]!;
      await tester.pumpWidget(makeWidgetTestable(builder(MockBuildContext())));

      // assert
      expect(find.byType(Lottie), findsOneWidget);
    }
  });
}
