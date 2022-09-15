import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

abstract class NavigationHelper {
  static final StreamController<String> _currentRoute =
      StreamController.broadcast();

  static void goTo(String path, {bool replace = false}) {
    if (replace) {
      Modular.to.navigate(path);
    } else {
      Modular.to.pushNamed(path);
    }
    _currentRoute.add(path);
  }

  static void back() {
    Modular.to.pop();
  }

  static Stream<String> get currentRoute {
    return _currentRoute.stream;
  }
}
