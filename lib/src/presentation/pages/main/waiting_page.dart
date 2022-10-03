import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  final NavigationController _navigationController = Modular.get();
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
                const Text('Sua solicitação de cadastro encontra-se em fase'),
                const Text(' de análise no momento.'),
                const Text('Em breve entraremos em contato...'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _authController.logout(
                    onSuccess: _navigationController.navigateToLoginPage,
                  ),
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
