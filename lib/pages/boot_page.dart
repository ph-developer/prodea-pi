import 'package:flutter/material.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/user_infos_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final authController = i<AuthController>();
  final donationsStore = i<DonationsStore>();
  final userInfosStore = i<UserInfosStore>();

  @override
  void initState() {
    super.initState();
    authController.init(() {
      donationsStore.init();
      userInfosStore.init();
    });
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
