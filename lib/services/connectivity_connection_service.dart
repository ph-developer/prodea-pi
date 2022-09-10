import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prodea/services/contracts/connection_service.dart';

class ConnectivityConnectionService implements IConnectionService {
  final Connectivity connectivity;
  final _internetConnection = StreamController<bool>.broadcast();

  ConnectivityConnectionService(
    this.connectivity,
  ) {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      _checkInternetConnection();
    });
  }

  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();

    return _parseConnectionStatus(result);
  }

  @override
  Stream<bool> connectionStateChanged() {
    return connectivity.onConnectivityChanged.map((result) {
      final state = _parseConnectionStatus(result);
      if (state) _checkInternetConnection();

      return state;
    });
  }

  bool _parseConnectionStatus(ConnectivityResult connectivityResult) {
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi;
  }

  @override
  Future<bool> hasInternetConnection() async {
    return await _internetConnection.stream.last;
  }

  @override
  Stream<bool> internetConnectionStateChanged() {
    return _internetConnection.stream;
  }

  Future<void> _checkInternetConnection() async {
    if (!await isConnected()) return _internetConnection.add(false);

    bool result = await _lookupInternetAddress('1.1.1.1');
    if (!result) result = await _lookupInternetAddress('208.69.38.205');
    if (!result) result = await _lookupInternetAddress('cloud.google.com/dns');

    _internetConnection.add(result);
  }

  Future<bool> _lookupInternetAddress(String address) async {
    try {
      final result = await InternetAddress.lookup(address);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}

    return false;
  }
}
