import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

Future<void> showUserDialog(
  BuildContext context, {
  required User user,
}) async {
  await showDialog(
    context: context,
    builder: (_) => UserDialog(user: user),
  );
}

class UserDialog extends StatelessWidget {
  final User user;

  const UserDialog({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(user.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CNPJ: ${user.cnpj}"),
            Text("Endereço: ${user.address}"),
            Text("Cidade: ${user.city}"),
            Text("Email: ${user.email}"),
            Text("Telefone: ${user.phoneNumber}"),
            Text("Nome do Responsável: ${user.responsibleName}"),
            Text("Sobre: ${user.about}"),
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
