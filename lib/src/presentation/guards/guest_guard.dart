import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../injector.dart';
import '../controllers/auth_controller.dart';

Future<String?> guestGuard(BuildContext context, GoRouterState state) async {
  final AuthController authController = inject();

  if (authController.isLoggedIn) return '/main';

  return null;
}
