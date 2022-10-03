import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../stores/users_store.dart';

Future<void> showDonorsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => DonorsDialog(),
  );
}

class DonorsDialog extends StatelessWidget {
  final UsersStore _usersStore = Modular.get();

  DonorsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Quem participa do projeto?'),
          SizedBox(height: 12),
          Text(
            'Atualmente, o projeto conta com os seguintes doadores:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDonorsList(),
              ],
            ),
          ),
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

  Widget _buildDonorsList() {
    return Observer(
      builder: (_) {
        final donors = _usersStore.donors;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: donors.length,
          itemBuilder: (_, index) {
            final donor = donors[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '- ${donor.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${donor.address}, ${donor.city}'),
                Text(donor.about),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }
}
