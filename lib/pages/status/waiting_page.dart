import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/injection.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  final authController = i<AuthController>();

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
                Text("Olá ${authController.currentUserInfo?.name}!"),
                const SizedBox(height: 12),
                const Text('Sua solicitação de cadastro encontra-se em fase'),
                const Text(' de análise no momento.'),
                const Text('Em breve entraremos em contato...'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    authController.logout();
                  },
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
