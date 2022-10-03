import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../controllers/connection_state_controller.dart';

class ConnectionOutlinedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final ConnectionStateController _connectionStateController = Modular.get();

  ConnectionOutlinedButton({
    this.onPressed,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => OutlinedButton(
        onPressed: _connectionStateController.isConnected ? onPressed : null,
        child: child,
      ),
    );
  }
}
