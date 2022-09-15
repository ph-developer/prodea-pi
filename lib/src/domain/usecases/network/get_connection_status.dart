import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../services/network_service.dart';

class GetConnectionStatus {
  final INetworkService _networkService;

  GetConnectionStatus(this._networkService);

  Future<bool> call() async {
    try {
      final connectionStatus = await _networkService.isConnected();

      return connectionStatus;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return false;
    }
  }
}
