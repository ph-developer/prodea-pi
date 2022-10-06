import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../injector.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../widgets/button/loading_outlined_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final NavigationController _navigationController = inject();
  final AuthController _authController = inject();
  var email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                _buildEmailField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 24),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/logo.svg',
        height: 100,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = _authController.isLoading;

          if (isLoading) {
            return const LoadingOutlinedButton();
          }

          return OutlinedButton(
            onPressed: () => _authController.sendPasswordResetEmail(
              email,
              onSuccess: _navigationController.navigateToLoginPage,
            ),
            child: const Text('Solicitar Redefinição de Senha'),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = _authController.isLoading;

          return OutlinedButton(
            onPressed:
                !isLoading ? _navigationController.navigateToLoginPage : null,
            child: const Text('Voltar'),
          );
        },
      ),
    );
  }
}
