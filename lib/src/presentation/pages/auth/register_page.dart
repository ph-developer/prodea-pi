import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/input_formatters.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../dialogs/city_select_dialog.dart';
import '../../stores/user_store.dart';
import '../../widgets/button/loading_outlined_button.dart';
import '../../widgets/layout/layout_breakpoint.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final NavigationController _navigationController = Modular.get();
  final AuthController _authController = Modular.get();
  final UserStore _userStore = Modular.get();
  final _cityController = TextEditingController(text: '');
  var _password = '';

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(),
                  LayoutBreakpoint(
                    xs: Column(
                      children: [
                        _buildEmailField(),
                        const SizedBox(height: 12),
                        _buildPasswordField(),
                      ],
                    ),
                    md: Row(
                      children: [
                        Flexible(child: _buildEmailField()),
                        const SizedBox(width: 12),
                        Flexible(child: _buildPasswordField()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBreakpoint(
                    xs: Column(
                      children: [
                        _buildCnpjField(),
                        const SizedBox(height: 12),
                        _buildNameField(),
                      ],
                    ),
                    md: Row(
                      children: [
                        Flexible(child: _buildCnpjField()),
                        const SizedBox(width: 12),
                        Flexible(child: _buildNameField()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBreakpoint(
                    xs: Column(
                      children: [
                        _buildAddressField(),
                        const SizedBox(height: 12),
                        _buildCityField(),
                        const SizedBox(height: 12),
                        _buildPhoneNumberField(),
                      ],
                    ),
                    md: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(child: _buildAddressField()),
                            const SizedBox(width: 12),
                            Flexible(child: _buildCityField()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPhoneNumberField(),
                      ],
                    ),
                    lg: Row(
                      children: [
                        Flexible(flex: 2, child: _buildAddressField()),
                        const SizedBox(width: 12),
                        Flexible(flex: 1, child: _buildCityField()),
                        const SizedBox(width: 12),
                        Flexible(flex: 1, child: _buildPhoneNumberField()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAboutField(),
                  const SizedBox(height: 12),
                  LayoutBreakpoint(
                    xs: Column(
                      children: [
                        _buildResponsibleNameField(),
                        const SizedBox(height: 12),
                        _buildResponsibleCpfField(),
                      ],
                    ),
                    md: Row(
                      children: [
                        Flexible(child: _buildResponsibleNameField()),
                        const SizedBox(width: 12),
                        Flexible(child: _buildResponsibleCpfField()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildIsDonorField(),
                  const SizedBox(height: 12),
                  _buildIsBeneficiaryField(),
                  const SizedBox(height: 12),
                  _buildTermsField(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                  const SizedBox(height: 24),
                  _buildNavigationButtons(),
                ],
              ),
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
      onChanged: (value) => _userStore.email = value,
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

  Widget _buildCnpjField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'CNPJ',
      ),
      onChanged: (value) => _userStore.cnpj = value,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        cnpjMaskInputFormatter,
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nome da Empresa/Entidade',
      ),
      onChanged: (value) => _userStore.name = value,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Endereço (Rua, Número e Bairro)',
      ),
      onChanged: (value) => _userStore.address = value,
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Cidade',
      ),
      keyboardType: TextInputType.none,
      controller: _cityController,
      onTap: () {
        showCitySelectDialog(
          context,
          onSelect: (value) {
            _userStore.city = value;
            _cityController.text = value;
          },
        );
      },
      readOnly: true,
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Telefone',
      ),
      onChanged: (value) => _userStore.phoneNumber = value,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        PhoneMaskInputFormatter(),
      ],
    );
  }

  Widget _buildAboutField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Sobre a Empresa/Entidade',
      ),
      onChanged: (value) => _userStore.about = value,
    );
  }

  Widget _buildResponsibleNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nome Completo do Responsável',
      ),
      onChanged: (value) => _userStore.responsibleName = value,
    );
  }

  Widget _buildResponsibleCpfField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'CPF do Responsável',
      ),
      onChanged: (value) => _userStore.responsibleCpf = value,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        cpfMaskInputFormatter,
      ],
    );
  }

  Widget _buildIsDonorField() {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: SizedBox(
              height: 20,
              width: 28,
              child: Observer(
                builder: (_) {
                  return Checkbox(
                    value: _userStore.isDonor,
                    onChanged: (value) => _userStore.isDonor = value == true,
                  );
                },
              ),
            ),
          ),
          TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
            text: 'Desejo cadastrar minha empresa/entidade como doadora.',
          ),
        ],
      ),
    );
  }

  Widget _buildIsBeneficiaryField() {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: SizedBox(
              height: 20,
              width: 28,
              child: Observer(
                builder: (_) {
                  return Checkbox(
                    value: _userStore.isBeneficiary,
                    onChanged: (value) =>
                        _userStore.isBeneficiary = value == true,
                  );
                },
              ),
            ),
          ),
          TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
            text: 'Desejo cadastrar minha empresa/entidade como beneficiária.',
          ),
        ],
      ),
    );
  }

  Widget _buildTermsField() {
    return const Text(
      'Ao solicitar seu cadastro, você concorda com nossos Termos de Uso. '
      'Para mais informações sobre nossas práticas de privacidade, acesse '
      'nossa Política de Privacidade.',
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = _authController.isLoading;
          final canSubmit = _password.isNotEmpty &&
              _userStore.email.isNotEmpty &&
              _userStore.cnpj.isNotEmpty &&
              _userStore.name.isNotEmpty &&
              _userStore.address.isNotEmpty &&
              _userStore.city.isNotEmpty &&
              _userStore.phoneNumber.isNotEmpty &&
              _userStore.about.isNotEmpty &&
              _userStore.responsibleName.isNotEmpty &&
              _userStore.responsibleCpf.isNotEmpty &&
              (_userStore.isBeneficiary || _userStore.isDonor);

          if (isLoading) {
            return const LoadingOutlinedButton();
          }

          return OutlinedButton(
            onPressed: canSubmit
                ? () => _authController.register(
                    _userStore.email, _password, _userStore.user,
                    onSuccess: _navigationController.navigateToMainPage)
                : null,
            child: const Text('Solicitar Cadastro'),
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
