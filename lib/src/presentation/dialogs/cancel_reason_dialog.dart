import 'package:flutter/material.dart';

Future<void> showCancelReasonDialog(
  BuildContext context, {
  void Function(String)? onOk,
}) async {
  await showDialog(
    context: context,
    builder: (_) => CancelReasonDialog(onOk: onOk),
  );
}

class CancelReasonDialog extends StatefulWidget {
  final void Function(String)? onOk;

  const CancelReasonDialog({this.onOk, Key? key}) : super(key: key);

  @override
  State<CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<CancelReasonDialog> {
  String value = '';

  void _setValue(String value) {
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancelar Doação'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Escreva o motivo do cancelamento da doação.'),
            TextFormField(
              autofocus: true,
              initialValue: '',
              onChanged: _setValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Voltar'),
        ),
        TextButton(
          onPressed: value.isEmpty
              ? null
              : () {
                  widget.onOk?.call(value);
                  Navigator.of(context).pop();
                },
          child: const Text('Cancelar Doação'),
        ),
      ],
    );
  }
}
