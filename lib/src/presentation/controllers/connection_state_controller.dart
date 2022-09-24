// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../domain/usecases/network/get_connection_status.dart';

part 'connection_state_controller.g.dart';

class ConnectionStateController = _ConnectionStateControllerBase
    with _$ConnectionStateController;

abstract class _ConnectionStateControllerBase with Store {
  final GetConnectionStatus _getConnectionStatus;
  final List<StreamSubscription> _subscriptions = [];

  _ConnectionStateControllerBase(this._getConnectionStatus);

  @observable
  bool isConnected = true;

  void init() {
    _subscriptions.map((subscription) => subscription.cancel());
    _subscriptions.clear();

    _subscriptions.addAll([
      _getConnectionStatus().listen((connectionStatus) {
        isConnected = connectionStatus;
      }),
    ]);
  }
}
