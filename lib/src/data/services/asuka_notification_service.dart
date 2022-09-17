import 'package:asuka/snackbars/asuka_snack_bar.dart';

import '../../domain/services/notification_service.dart';

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
