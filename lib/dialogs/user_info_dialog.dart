import 'package:flutter/material.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/stores/beneficiaries_store.dart';

Future<void> showUserInfoDialog(
  BuildContext context, {
  required String id,
}) async {
  await showDialog(
    context: context,
    builder: (_) => UserInfoDialog(id: id),
  );
}

class UserInfoDialog extends StatelessWidget {
  final beneficiariesStore = i<BeneficiariesStore>();
  final String id;

  UserInfoDialog({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final beneficiary = beneficiariesStore.getBeneficiaryById(id);

    return AlertDialog(
      title: Text(beneficiary.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CNPJ: ${beneficiary.cnpj}"),
            Text("Endereço: ${beneficiary.address}"),
            Text("Cidade: ${beneficiary.city}"),
            Text("Email: ${beneficiary.email}"),
            Text("Telefone: ${beneficiary.phoneNumber}"),
            Text("Nome do Responsável: ${beneficiary.responsibleName}"),
            Text("Sobre: ${beneficiary.about}"),
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
