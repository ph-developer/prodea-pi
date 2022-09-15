import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/helpers/navigation.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connection_state_controller.dart';
import '../controllers/main_page_controller.dart';
import '../dialogs/no_connection_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainPageController _mainPageController = Modular.get();
  final AuthController _authController = Modular.get();
  final ConnectionStateController _connectionStateController = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final pageInfo = _mainPageController.currentPageInfo;

        return Scaffold(
          body: const RouterOutlet(),
          appBar: AppBar(
            backgroundColor: !_connectionStateController.isConnected
                ? Colors.redAccent
                : null,
            title: Row(
              children: [
                if (pageInfo != null) Icon(pageInfo.icon),
                const SizedBox(width: 12),
                if (pageInfo != null) Text(pageInfo.title),
              ],
            ),
            actions: [
              if (!_connectionStateController.isConnected)
                IconButton(
                  onPressed: () => showNoConnectionDialog(context),
                  icon: const Icon(Icons.wifi_off_rounded),
                ),
              IconButton(
                onPressed: () => NavigationHelper.goTo('/profile'),
                icon: const Icon(Icons.person_rounded),
              ),
              if (_authController.isAdmin)
                IconButton(
                  onPressed: () => NavigationHelper.goTo('/admin'),
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                ),
            ],
          ),
          bottomNavigationBar: (_mainPageController.pageInfos.length >= 2)
              ? NavigationBar(
                  destinations: _mainPageController.pageInfos
                      .map((pageInfo) => NavigationDestination(
                            icon: Icon(pageInfo.icon),
                            label: pageInfo.abbrTitle,
                          ))
                      .toList(),
                  selectedIndex: _mainPageController.currentPageIndex,
                  onDestinationSelected: _mainPageController.navigateToPage,
                )
              : null,
        );
      },
    );
  }
}
