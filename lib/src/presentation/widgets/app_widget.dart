import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';

import '../../../router.dart';
import '../../themes/main_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'PRODEA',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        builder: Asuka.builder,
        routerConfig: router,
      ),
    );
  }
}
