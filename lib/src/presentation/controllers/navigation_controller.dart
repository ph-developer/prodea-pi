// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../domain/usecases/navigation/get_current_route.dart';
import '../../domain/usecases/navigation/go_back.dart';
import '../../domain/usecases/navigation/go_to.dart';

part 'navigation_controller.g.dart';

class NavigationController = _NavigationControllerBase
    with _$NavigationController;

abstract class _NavigationControllerBase with Store {
  final GetCurrentRoute _getCurrentRoute;
  final GoTo _goTo;
  final GoBack _goBack;
  final List<StreamSubscription> _subscriptions = [];

  _NavigationControllerBase(
    this._getCurrentRoute,
    this._goTo,
    this._goBack,
  );

  @observable
  String currentRoute = '/';

  @action
  void fetchCurrentRoute() {
    _subscriptions.map((subscription) => subscription.cancel());
    _subscriptions.clear();

    _subscriptions.addAll([
      _getCurrentRoute().listen((route) {
        currentRoute = route;
      }),
    ]);
  }

  @action
  void navigateBack() {
    _goBack();
  }

  @action
  void navigateToLoginPage() {
    _goTo('/login', replace: true);
  }

  @action
  void navigateToForgotPasswordPage() {
    _goTo('/forgot', replace: true);
  }

  @action
  void navigateToRegisterPage() {
    _goTo('/register', replace: true);
  }

  @action
  void navigateToMainPage() {
    _goTo('/main', replace: true);
  }

  @action
  void navigateToAdminPage() {
    _goTo('/admin');
  }

  @action
  void navigateToProfilePage() {
    _goTo('/profile');
  }
}
