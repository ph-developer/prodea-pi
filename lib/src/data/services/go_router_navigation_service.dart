import 'dart:async';

import 'package:go_router/go_router.dart';

import '../../../router.dart';
import '../../domain/services/navigation_service.dart';

class GoRouterNavigationService implements INavigationService {
  late GoRouter _router;
  static final StreamController<String> _currentRoute =
      StreamController.broadcast();

  GoRouterNavigationService([GoRouter? goRouter]) {
    _router = goRouter ?? router;
  }

  @override
  void goTo(String path, {bool replace = false}) {
    _currentRoute.add(path);
    if (replace) {
      _router.replace(path);
    } else {
      _router.push(path);
    }
  }

  @override
  void goBack() {
    _router.pop();
    _currentRoute.add(_router.location);
  }

  @override
  Stream<String> currentRoute() {
    return _currentRoute.stream;
  }
}
