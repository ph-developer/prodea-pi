import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prodea/main.dart' as app;
import 'package:prodea/src/presentation/pages/auth/login_page.dart';
import 'package:prodea/src/presentation/pages/main_page.dart';

import '../test/test_helpers/finder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testes E2E', () {
    testWidgets(
      'deve testar a página de login',
      (tester) async {
        await tester.runAsync(() => app.main());
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(OutlinedButton), findsNWidgets(3));

        final emailFormField = findWidgetByType<TextFormField>(TextFormField);
        await tester.enterText(find.byWidget(emailFormField), 'admin@test.dev');

        final passwordFormField =
            findWidgetByType<TextFormField>(TextFormField, 1);
        await tester.enterText(find.byWidget(passwordFormField), '123456');

        final submitButton = findWidgetByType<OutlinedButton>(OutlinedButton);
        await tester.tap(find.byWidget(submitButton));

        await tester.pumpAndSettle();
        expect(find.byType(MainPage), findsOneWidget);
      },
    );
  });
}
