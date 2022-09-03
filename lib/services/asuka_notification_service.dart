import 'package:asuka/asuka.dart';
import 'package:prodea/services/contracts/notification_service.dart';

class AsukaNotificationService implements INotificationService {
  @override
  void notifySuccess(String message) {
    AsukaSnackbar.success(message).show();
  }

  @override
  void notifyError(String message) {
    AsukaSnackbar.alert(message).show();
  }
}
