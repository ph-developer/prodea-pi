import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/user.dart';
import '../../controllers/connection_state_controller.dart';
import '../../stores/users_store.dart';
import '../../widgets/app_bar/connection_app_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final UsersStore _usersStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: ConnectionAppBar(
          icon: const Icon(Icons.admin_panel_settings_rounded),
          title: 'Administração',
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16),
            child: Observer(
              builder: (context) {
                final userInfos = _usersStore.commonUsers;

                if (userInfos.isEmpty) {
                  return const Text(
                    'Infelizmente não há usuários cadastrados...',
                  );
                }

                return ListView.builder(
                  itemCount: userInfos.length,
                  itemBuilder: (context, index) {
                    final userInfo = userInfos[index];
                    return _buildUserCard(userInfo);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name),
            Text("CNPJ: ${user.cnpj}"),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Endereço: ${user.address}"),
            Text("Cidade: ${user.city}"),
            Text("Email: ${user.email}"),
            Text("Telefone: ${user.phoneNumber}"),
            Text("Nome do Responsável: ${user.responsibleName}"),
            Text("CPF do Responsável: ${user.responsibleCpf}"),
            Text("Sobre: ${user.about}"),
            if (user.isDonor && user.isBeneficiary)
              const Text('Perfil: Doador(a) e Beneficiário(a)'),
            if (user.isDonor && !user.isBeneficiary)
              const Text('Perfil: Doador(a)'),
            if (!user.isDonor && user.isBeneficiary)
              const Text('Perfil: Beneficiário(a)'),
            if (user.status == AuthorizationStatus.waiting)
              const Text('Situação: Aguardando Verificação'),
            if (user.status == AuthorizationStatus.authorized)
              const Text('Situação: Autorizado'),
            if (user.status == AuthorizationStatus.denied)
              const Text('Situação: Não Autorizado'),
            const SizedBox(height: 8),
            if (user.status == AuthorizationStatus.waiting ||
                user.status == AuthorizationStatus.denied)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: _connectionStateController.isConnected
                        ? () {
                            _usersStore.setUserAsAuthorized(user);
                          }
                        : null,
                    child: const Text('Autorizar'),
                  ),
                ),
              ),
            if (user.status == AuthorizationStatus.waiting ||
                user.status == AuthorizationStatus.authorized)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: _connectionStateController.isConnected
                        ? () {
                            _usersStore.setUserAsDenied(user);
                          }
                        : null,
                    child: const Text('Negar Autorização'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
