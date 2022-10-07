import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/boot_widget.dart';
import 'package:lottie/lottie.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('deve testar a tela de boot', (tester) async {
    // arrange
    await tester.pumpWidget(BootWidget(widgetsBinding: binding));

    // assert
    expect(find.byType(BootWidget), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
  });
}
