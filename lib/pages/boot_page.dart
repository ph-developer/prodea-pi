import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/controllers/connection_state_controller.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/cities_store.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/user_infos_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final connectionStateController = i<ConnectionStateController>();
  final authController = i<AuthController>();
  final donationsStore = i<DonationsStore>();
  final userInfosStore = i<UserInfosStore>();
  final citiesStore = i<CitiesStore>();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await citiesStore.init();
    connectionStateController.init();
    authController.init(
      afterLoginCallback: () {
        donationsStore.init();
        userInfosStore.init();
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
