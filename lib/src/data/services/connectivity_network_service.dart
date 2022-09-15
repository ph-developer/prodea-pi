import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/errors/failures.dart';
import '../../domain/services/network_service.dart';

class ConnectivityNetworkService implements INetworkService {
  final Connectivity _connectivity;

  ConnectivityNetworkService(this._connectivity);

  @override
  Future<bool> isConnected() async {
    try {
      return await _checkInternetConnection();
    } catch (e) {
      throw InternetConnectionFailure();
    }
  }

  Future<bool> _checkInternetConnection() async {
    final hasConnection = await _checkConnection();
    if (!hasConnection) return false;

    var status = await _lookupInternetAddress('1.1.1.1');
    if (!status) status = await _lookupInternetAddress('208.69.38.205');
    if (!status) status = await _lookupInternetAddress('cloud.google.com/dns');

    return status;
  }

  Future<bool> _checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> _lookupInternetAddress(String address) async {
    try {
      final result = await InternetAddress.lookup(address);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }
}
