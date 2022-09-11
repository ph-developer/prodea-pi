import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/extensions/input_formatters.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/cities_store.dart';
import 'package:prodea/stores/user_info_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authController = i<AuthController>();
  final userInfoStore = i<UserInfoStore>();
  final citiesStore = i<CitiesStore>();
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              _buildEmailField(),
              const SizedBox(height: 12),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildCnpjField(),
              const SizedBox(height: 12),
              _buildNameField(),
              const SizedBox(height: 12),
              _buildAddressField(),
              const SizedBox(height: 12),
              _buildCityField(),
              const SizedBox(height: 12),
              _buildPhoneNumberField(),
              const SizedBox(height: 12),
              _buildAboutField(),
              const SizedBox(height: 12),
              _buildResponsibleNameField(),
              const SizedBox(height: 12),
              _buildResponsibleCpfField(),
              const SizedBox(height: 12),
              _buildIsDonorField(),
              const SizedBox(height: 12),
              _buildIsBeneficiaryField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildNavigationButtons(),
            ],
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
      onChanged: (value) => userInfoStore.email = value,
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
          password = value;
        });
      },
    );
  }

  Widget _buildCnpjField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'CNPJ',
      ),
      onChanged: (value) => userInfoStore.cnpj = value,
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
      onChanged: (value) => userInfoStore.name = value,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Endereço (Rua, Número e Bairro)',
      ),
      onChanged: (value) => userInfoStore.address = value,
    );
  }

  Widget _buildCityField() {
    return Observer(
      builder: (_) {
        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Cidade',
          ),
          items: [
            const DropdownMenuItem(
              value: '',
              child: Text(''),
            ),
            ...citiesStore.cities.map(
              (city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              },
            ),
          ],
          value: userInfoStore.city,
          isExpanded: true,
          onChanged: (value) => userInfoStore.city = value!,
        );
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Telefone',
      ),
      onChanged: (value) => userInfoStore.phoneNumber = value,
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
      onChanged: (value) => userInfoStore.about = value,
    );
  }

  Widget _buildResponsibleNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nome Completo do Responsável',
      ),
      onChanged: (value) => userInfoStore.responsibleName = value,
    );
  }

  Widget _buildResponsibleCpfField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'CPF do Responsável',
      ),
      onChanged: (value) => userInfoStore.responsibleCpf = value,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        cpfMaskInputFormatter,
      ],
    );
  }

  Widget _buildIsDonorField() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: SizedBox(
                height: 20,
                width: 28,
                child: Observer(
                  builder: (_) {
                    return Checkbox(
                      value: userInfoStore.isDonor,
                      onChanged: (value) =>
                          userInfoStore.isDonor = value == true,
                    );
                  },
                ),
              ),
            ),
            const TextSpan(
              style: TextStyle(
                fontSize: 12,
              ),
              text: 'Desejo cadastrar minha empresa/entidade como doadora.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIsBeneficiaryField() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: SizedBox(
                height: 20,
                width: 28,
                child: Observer(
                  builder: (_) {
                    return Checkbox(
                      value: userInfoStore.isBeneficiary,
                      onChanged: (value) =>
                          userInfoStore.isBeneficiary = value == true,
                    );
                  },
                ),
              ),
            ),
            const TextSpan(
              style: TextStyle(
                fontSize: 12,
              ),
              text: 'Desejo cadastrar minha empresa/entidade como '
                  'beneficiária.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = authController.isLoading;
          final canSubmit = password.isNotEmpty &&
              userInfoStore.email.isNotEmpty &&
              userInfoStore.cnpj.isNotEmpty &&
              userInfoStore.name.isNotEmpty &&
              userInfoStore.address.isNotEmpty &&
              userInfoStore.city.isNotEmpty &&
              userInfoStore.phoneNumber.isNotEmpty &&
              userInfoStore.about.isNotEmpty &&
              userInfoStore.responsibleName.isNotEmpty &&
              userInfoStore.responsibleCpf.isNotEmpty &&
              (userInfoStore.isBeneficiary || userInfoStore.isDonor);

          if (isLoading) {
            return const OutlinedButton(
              onPressed: null,
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return OutlinedButton(
            onPressed: canSubmit
                ? () => authController.register(
                      userInfoStore.email,
                      password,
                      userInfoStore.userInfo,
                    )
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
          final isLoading = authController.isLoading;

          return OutlinedButton(
            onPressed: !isLoading ? authController.navigateToLoginPage : null,
            child: const Text('Voltar'),
          );
        },
      ),
    );
  }
}
