import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prodea/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testes E2E', () {
    testWidgets('Carregamento da página inicial', (tester) async {
      await tester.runAsync(() => app.main());
      await tester.pumpAndSettle();
    });
  });
}
