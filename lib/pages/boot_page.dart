import 'package:flutter/material.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/beneficiaries_store.dart';
import 'package:prodea/stores/donors_store.dart';
import 'package:prodea/stores/users_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final authController = i<AuthController>();
  final beneficiariesStore = i<BeneficiariesStore>();
  final usersStore = i<UsersStore>();
  final donorsStore = i<DonorsStore>();

  @override
  void initState() {
    super.initState();
    beneficiariesStore.fetchData();
    usersStore.fetchData();
    donorsStore.fetchData();
    authController.init();
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
