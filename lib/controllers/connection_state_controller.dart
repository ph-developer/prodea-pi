// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:prodea/services/contracts/connection_service.dart';
import 'package:prodea/services/contracts/notification_service.dart';

part 'connection_state_controller.g.dart';

class ConnectionStateController = _ConnectionStateControllerBase
    with _$ConnectionStateController;

abstract class _ConnectionStateControllerBase with Store {
  final IConnectionService connectionService;
  final INotificationService notificationService;

  _ConnectionStateControllerBase(
    this.connectionService,
    this.notificationService,
  );

  @observable
  bool isConnected = true;

  void init() {
    connectionService.internetConnectionStateChanged().listen((status) {
      isConnected = status;
    });
  }
}
