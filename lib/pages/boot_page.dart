import 'package:flutter/material.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/auth_store.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  final authStore = i<AuthStore>();

  @override
  void initState() {
    super.initState();
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
