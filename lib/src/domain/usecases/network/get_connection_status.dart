import '../../../../core/errors/failures.dart';
import '../../services/network_service.dart';
import '../../services/notification_service.dart';

class GetConnectionStatus {
  final INotificationService _notificationService;
  final INetworkService _networkService;

  GetConnectionStatus(this._networkService, this._notificationService);

  Future<bool> call() async {
    try {
      final connectionStatus = await _networkService.isConnected();

      return connectionStatus;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return false;
    }
  }
}
