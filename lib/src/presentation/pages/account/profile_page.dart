import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/user_info.dart';
import '../../controllers/auth_controller.dart';

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
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.person_rounded),
            SizedBox(width: 12),
            Text('Meu Perfil'),
          ],
        ),
      ),
      body: Observer(
        builder: (_) {
          final userInfo = _authController.currentUserInfo;

          if (userInfo == null) return Container();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userInfo.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "CNPJ: ${userInfo.cnpj}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                  const SizedBox(height: 12),
                  Text("Endereço: ${userInfo.address}"),
                  Text("Cidade: ${userInfo.city}"),
                  const SizedBox(height: 12),
                  Text("Email: ${userInfo.email}"),
                  Text("Telefone: ${userInfo.phoneNumber}"),
                  const SizedBox(height: 12),
                  Text("Nome do Responsável: ${userInfo.responsibleName}"),
                  Text("CPF do Responsável: ${userInfo.responsibleCpf}"),
                  const SizedBox(height: 12),
                  Text("Sobre: ${userInfo.about}"),
                  const SizedBox(height: 12),
                  if (userInfo.isDonor && userInfo.isBeneficiary)
                    const Text('Perfil: Doador(a) e Beneficiário(a)'),
                  if (userInfo.isDonor && !userInfo.isBeneficiary)
                    const Text('Perfil: Doador(a)'),
                  if (!userInfo.isDonor && userInfo.isBeneficiary)
                    const Text('Perfil: Beneficiário(a)'),
                  const SizedBox(height: 12),
                  if (userInfo.status == AuthorizationStatus.waiting)
                    const Text(
                      'Situação: Aguardando Verificação',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (userInfo.status == AuthorizationStatus.authorized)
                    const Text(
                      'Situação: Autorizado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (userInfo.status == AuthorizationStatus.denied)
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
