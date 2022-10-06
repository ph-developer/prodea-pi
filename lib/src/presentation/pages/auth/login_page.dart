import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../injector.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../widgets/button/loading_outlined_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final NavigationController _navigationController = inject();
  final AuthController _authController = inject();
  var _email = '';
  var _password = '';

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
                const SizedBox(height: 12),
                _buildPasswordField(),
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
          _email = value;
        });
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Senha',
      ),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      onChanged: (value) {
        setState(() {
          _password = value;
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
            onPressed: () => _authController.login(
              _email,
              _password,
              onSuccess: _navigationController.navigateToMainPage,
            ),
            child: const Text('Entrar'),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Observer(
      builder: (_) {
        final isLoading = _authController.isLoading;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: !isLoading
                    ? _navigationController.navigateToForgotPasswordPage
                    : null,
                child: const Text('Recuperar Senha'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: !isLoading
                    ? _navigationController.navigateToRegisterPage
                    : null,
                child: const Text('Solicitar Cadastro'),
              ),
            ),
          ],
        );
      },
    );
  }
}
