import 'package:asuka/asuka.dart';

abstract class NotificationHelper {
  static void notifySuccess(String message) {
    AsukaSnackbar.success(message).show();
  }

  static void notifyError(String message) {
    AsukaSnackbar.alert(message).show();
  }
}
