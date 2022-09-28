import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

abstract class NavigationHelper {
  static final StreamController<String> _currentRoute =
      StreamController.broadcast();

  static void goTo(String path, {bool replace = false}) {
    _currentRoute.add(path);
    if (replace) {
      Modular.to.navigate(path);
    } else {
      Modular.to.pushNamed(path);
    }
  }

  static void back() {
    Modular.to.pop();
    _currentRoute.add(Modular.to.path);
  }

  static Stream<String> get currentRoute {
    return _currentRoute.stream;
  }
}
