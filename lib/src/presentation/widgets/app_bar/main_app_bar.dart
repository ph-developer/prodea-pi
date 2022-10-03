import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../layout/breakpoint.dart';
import 'connection_app_bar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon? icon;
  final String? title;
  final List<Widget>? actions;
  final AuthController _authController = Modular.get();
  final NavigationController _navigationController = Modular.get();

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
          actions:
              MediaQuery.of(context).size.width >= Breakpoint.md.minDimension
                  ? _buildWebActions(
                      _authController.isLoggedIn,
                      _authController.isAdmin,
                      _authController.currentUser?.name,
                    )
                  : _buildMobileActions(
                      _authController.isLoggedIn,
                      _authController.isAdmin,
                    ),
        );
      },
    );
  }

  List<Widget> _buildWebActions(bool isLoggedIn, bool isAdmin, String? name) {
    final List<Widget> widgets = [];

    if (isLoggedIn) {
      if (isAdmin) {
        widgets.addAll([
          TextButton.icon(
            onPressed: _navigationController.navigateToAdminPage,
            icon: const Icon(Icons.admin_panel_settings_rounded),
            label: const Text('Administração'),
          ),
        ]);
      }

      if (name != null) {
        widgets.addAll([
          TextButton.icon(
            onPressed: _navigationController.navigateToProfilePage,
            icon: const Icon(Icons.person_rounded),
            label: Text(name),
          ),
        ]);
      }

      widgets.addAll([
        TextButton.icon(
          onPressed: () => _authController.logout(
            onSuccess: _navigationController.navigateToLoginPage,
          ),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sair'),
        ),
      ]);
    }

    if (actions != null) {
      widgets.addAll(actions!);
    }

    return widgets;
  }

  List<Widget> _buildMobileActions(bool isLoggedIn, bool isAdmin) {
    final List<Widget> widgets = [];

    if (isLoggedIn) {
      widgets.addAll([
        IconButton(
          onPressed: _navigationController.navigateToProfilePage,
          icon: const Icon(Icons.person_rounded),
        ),
      ]);

      if (isAdmin) {
        widgets.addAll([
          IconButton(
            onPressed: _navigationController.navigateToAdminPage,
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
