import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/data/services/asuka_notification_service.dart';

void main() {
  late AsukaNotificationService asukaNotificationService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    asukaNotificationService = AsukaNotificationService();
  });

  group('notifySuccess', () {});

  group('notifyError', () {});
}
