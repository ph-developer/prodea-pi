import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/helpers/navigation.dart';
import '../controllers/auth_controller.dart';
import 'connection_app_bar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;
  final String? title;
  final List<Widget>? actions;
  final AuthController _authController = Modular.get();

  @override
  final Size preferredSize;

  MainAppBar({this.icon, this.title, this.actions, Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ConnectionAppBar(
          icon: icon,
          title: title,
          actions: _buildActions(
              _authController.isLoggedIn, _authController.isAdmin),
        );
      },
    );
  }

  List<Widget> _buildActions(bool isLoggedIn, bool isAdmin) {
    final List<Widget> widgets = [];

    if (isLoggedIn) {
      widgets.addAll([
        IconButton(
          onPressed: () => NavigationHelper.goTo('/profile'),
          icon: const Icon(Icons.person_rounded),
        ),
      ]);

      if (isAdmin) {
        widgets.addAll([
          IconButton(
            onPressed: () => NavigationHelper.goTo('/admin'),
            icon: const Icon(Icons.admin_panel_settings_rounded),
          ),
        ]);
      }
    }

    if (actions != null) {
      widgets.addAll(actions!);
    }

    return widgets;
  }
}
