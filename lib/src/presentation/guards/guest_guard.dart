import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../controllers/auth_controller.dart';

class GuestGuard extends RouteGuard {
  String? _redirectTo;

  @override
  String? get redirectTo => _redirectTo;

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    final AuthController authController = Modular.get();

    await authController.isReady();

    if (!authController.isLoggedIn) return true;

    if (authController.isAuthorized) {
      if (authController.isDonor) {
        _redirectTo = '/main/donate';
      } else if (authController.isBeneficiary) {
        _redirectTo = '/main/available-donations';
      }
    } else if (authController.isDenied) {
      _redirectTo = '/denied';
    } else {
      _redirectTo = '/waiting';
    }

    return false;
  }
}
