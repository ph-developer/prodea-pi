import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/user.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/connection_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConnectionAppBar(
        icon: Icons.person_rounded,
        title: 'Meu Perfil',
      ),
      body: Observer(
        builder: (_) {
          final user = _authController.currentUser;

          if (user == null) return Container();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "CNPJ: ${user.cnpj}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                  const SizedBox(height: 12),
                  Text("Endereço: ${user.address}"),
                  Text("Cidade: ${user.city}"),
                  const SizedBox(height: 12),
                  Text("Email: ${user.email}"),
                  Text("Telefone: ${user.phoneNumber}"),
                  const SizedBox(height: 12),
                  Text("Nome do Responsável: ${user.responsibleName}"),
                  Text("CPF do Responsável: ${user.responsibleCpf}"),
                  const SizedBox(height: 12),
                  Text("Sobre: ${user.about}"),
                  const SizedBox(height: 12),
                  if (user.isDonor && user.isBeneficiary)
                    const Text('Perfil: Doador(a) e Beneficiário(a)'),
                  if (user.isDonor && !user.isBeneficiary)
                    const Text('Perfil: Doador(a)'),
                  if (!user.isDonor && user.isBeneficiary)
                    const Text('Perfil: Beneficiário(a)'),
                  const SizedBox(height: 12),
                  if (user.status == AuthorizationStatus.waiting)
                    const Text(
                      'Situação: Aguardando Verificação',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (user.status == AuthorizationStatus.authorized)
                    const Text(
                      'Situação: Autorizado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (user.status == AuthorizationStatus.denied)
                    const Text(
                      'Situação: Não Autorizado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
      ),
    );
  }
}
