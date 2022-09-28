import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../controllers/auth_controller.dart';

class DeniedPage extends StatefulWidget {
  const DeniedPage({Key? key}) : super(key: key);

  @override
  State<DeniedPage> createState() => _DeniedPageState();
}

class _DeniedPageState extends State<DeniedPage> {
  final AuthController _authController = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Olá ${_authController.currentUser?.name}!"),
                const SizedBox(height: 12),
                const Text('Infelizmente seu cadastro foi negado.'),
                const Text('Em breve entraremos em contato...'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _authController.logout,
                  child: const Text('Sair'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
