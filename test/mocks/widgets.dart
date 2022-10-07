import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:prodea/router.dart';

Widget makeWidgetTestable(Widget widget) {
  return MaterialApp(
    builder: Asuka.builder,
    home: widget,
  );
}

Widget makeDialogTestable(Key scaffoldKey) {
  return MaterialApp(
    builder: Asuka.builder,
    home: Scaffold(
      key: scaffoldKey,
    ),
  );
}

Widget makeApp() {
  return MaterialApp.router(
    builder: Asuka.builder,
    routerConfig: router,
  );
}
