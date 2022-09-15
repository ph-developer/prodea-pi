import 'package:flutter/material.dart';

Future<void> showNoConnectionDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => const NoConnectionDialog(),
  );
}

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sem conexão com a internet...'),
      content: const SingleChildScrollView(
        child: Text('Você não está conectado à internet no momento. Enquanto '
            'não for reestabelecida a conexão, não será possível fazer '
            'postagens ou alterações. Os dados que estão sendo exibidos '
            'foram carregados na última conexão com a internet. Ao '
            'reestabelecer a conexão você voltará a receber atualizações em '
            'tempo real.'),
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
