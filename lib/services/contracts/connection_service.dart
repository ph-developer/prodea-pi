abstract class IConnectionService {
  Future<bool> isConnected();
  Stream<bool> connectionStateChanged();
  Future<bool> hasInternetConnection();
  Stream<bool> internetConnectionStateChanged();
}
