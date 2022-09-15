import 'package:flutter/material.dart';

import '../../domain/entities/user_info.dart';

Future<void> showUserInfoDialog(
  BuildContext context, {
  required UserInfo userInfo,
}) async {
  await showDialog(
    context: context,
    builder: (_) => UserInfoDialog(userInfo: userInfo),
  );
}

class UserInfoDialog extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoDialog({required this.userInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(userInfo.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CNPJ: ${userInfo.cnpj}"),
            Text("Endereço: ${userInfo.address}"),
            Text("Cidade: ${userInfo.city}"),
            Text("Email: ${userInfo.email}"),
            Text("Telefone: ${userInfo.phoneNumber}"),
            Text("Nome do Responsável: ${userInfo.responsibleName}"),
            Text("Sobre: ${userInfo.about}"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Voltar'),
        ),
      ],
    );
  }
}
