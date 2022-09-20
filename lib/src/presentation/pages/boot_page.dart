import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../controllers/auth_controller.dart';
import '../controllers/connection_state_controller.dart';
import '../controllers/main_page_controller.dart';
import '../stores/cities_store.dart';
import '../stores/donations_store.dart';
import '../stores/users_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final AuthController _authController = Modular.get();
  final MainPageController _mainPageController = Modular.get();
  final DonationsStore _donationsStore = Modular.get();
  final UsersStore _usersStore = Modular.get();
  final CitiesStore _citiesStore = Modular.get();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    _mainPageController.init();
    _citiesStore.init();
    _connectionStateController.init();
    _authController.init(
      afterLoginCallback: () {
        _donationsStore.init();
        _usersStore.init();
      },
      afterNavigationCallback: () {
        FlutterNativeSplash.remove();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
