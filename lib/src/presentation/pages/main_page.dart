import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../controllers/main_page_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainPageController _mainPageController = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          body: const RouterOutlet(),
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
