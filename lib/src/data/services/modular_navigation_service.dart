import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/services/navigation_service.dart';

class ModularNavigationService implements INavigationService {
  static final StreamController<String> _currentRoute =
      StreamController.broadcast();

  @override
  void goTo(String path, {bool replace = false}) {
    _currentRoute.add(path);
    if (replace) {
      Modular.to.navigate(path);
    } else {
      Modular.to.pushNamed(path);
    }
  }

  @override
  void goBack() {
    Modular.to.pop();
    _currentRoute.add(Modular.to.path);
  }

  @override
  Stream<String> currentRoute() {
    return _currentRoute.stream;
  }
}
