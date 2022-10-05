import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../injector.dart';
import '../controllers/auth_controller.dart';

class GuestGuard extends RouteGuard {
  GuestGuard() : super(redirectTo: '/main');

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    final AuthController authController = inject();

    return !authController.isLoggedIn;
  }
}
