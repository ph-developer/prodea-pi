import '../../../../core/errors/failures.dart';
import '../../services/network_service.dart';
import '../../services/notification_service.dart';

class GetConnectionStatus {
  final INotificationService _notificationService;
  final INetworkService _networkService;

  GetConnectionStatus(this._networkService, this._notificationService);

  Stream<bool> call() async* {
    yield await _checkConnection();
    yield* Stream.periodic(const Duration(seconds: 15))
        .asyncMap((_) async => await _checkConnection());
  }

  Future<bool> _checkConnection() async {
    try {
      final connectionStatus = await _networkService.isConnected();

      return connectionStatus;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return false;
    }
  }
}
