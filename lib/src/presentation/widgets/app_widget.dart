import 'package:asuka/asuka.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../injector.dart';
import '../../themes/main_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connection_state_controller.dart';
import '../stores/cities_store.dart';
import '../stores/users_store.dart';
import 'boot_widget.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final ConnectionStateController _connectionStateController = inject();
  final AuthController _authController = inject();
  final UsersStore _usersStore = inject();
  final CitiesStore _citiesStore = inject();
  bool isStarting = true;

  @override
  void initState() {
    super.initState();
    if (isStarting) _boot();
  }

  Future<void> _boot() async {
    await _authController.fetchCurrentUser();

    _connectionStateController.fetchConnectionStatus();
    _citiesStore.fetchCities();
    _usersStore.fetchUsers();

    if (kIsWeb && Uri.base.toString().endsWith('/#/')) {
      Modular.setInitialRoute('/');
    } else if (_authController.isLoggedIn) {
      Modular.setInitialRoute('/main');
    } else {
      Modular.setInitialRoute('/login');
    }

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isStarting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isStarting) {
      return const BootWidget();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'PRODEA',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        builder: Asuka.builder,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      ),
    );
  }
}
