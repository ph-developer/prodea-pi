import 'package:flutter/material.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/auth_store.dart';
import 'package:prodea/stores/beneficiaries_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final authStore = i<AuthStore>();
  final beneficiariesStore = i<BeneficiariesStore>();

  @override
  void initState() {
    super.initState();
    beneficiariesStore.fetchData();
    authStore.fetchUser();
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
