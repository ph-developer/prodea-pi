// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../core/mixins/stream_subscriber.dart';
import '../../domain/usecases/network/get_connection_status.dart';

part 'connection_state_controller.g.dart';

class ConnectionStateController = _ConnectionStateControllerBase
    with _$ConnectionStateController;

abstract class _ConnectionStateControllerBase with Store, StreamSubscriber {
  final GetConnectionStatus _getConnectionStatus;

  _ConnectionStateControllerBase(this._getConnectionStatus);

  @observable
  bool isConnected = true;

  @action
  Future<void> fetchConnectionStatus() async {
    await unsubscribeAll();
    await subscribe(_getConnectionStatus(), (connectionStatus) {
      isConnected = connectionStatus;
    });
  }
}
