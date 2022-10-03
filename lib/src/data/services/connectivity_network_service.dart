import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/errors/failures.dart';
import '../../domain/services/network_service.dart';

class ConnectivityNetworkService implements INetworkService {
  final Connectivity _connectivity;
  final _dnsList = ['1.1.1.1', '208.69.38.205', 'cloud.google.com/dns'];

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

    for (var dns in _dnsList) {
      final status = await _lookupInternetAddress(dns);
      if (status) return true;
    }

    return false;
  }

  Future<bool> _checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> _lookupInternetAddress(String address) async {
    if (kIsWeb) return true;

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
