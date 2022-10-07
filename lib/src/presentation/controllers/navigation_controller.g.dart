// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NavigationController on _NavigationControllerBase, Store {
  late final _$currentRouteAtom =
      Atom(name: '_NavigationControllerBase.currentRoute', context: context);

  @override
  String get currentRoute {
    _$currentRouteAtom.reportRead();
    return super.currentRoute;
  }

  @override
  set currentRoute(String value) {
    _$currentRouteAtom.reportWrite(value, super.currentRoute, () {
      super.currentRoute = value;
    });
  }

  late final _$fetchCurrentRouteAsyncAction = AsyncAction(
      '_NavigationControllerBase.fetchCurrentRoute',
      context: context);

  @override
  Future<void> fetchCurrentRoute() {
    return _$fetchCurrentRouteAsyncAction.run(() => super.fetchCurrentRoute());
  }

  late final _$_NavigationControllerBaseActionController =
      ActionController(name: '_NavigationControllerBase', context: context);

  @override
  void navigateBack() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateBack');
    try {
      return super.navigateBack();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToLoginPage() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateToLoginPage');
    try {
      return super.navigateToLoginPage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToForgotPasswordPage() {
    final _$actionInfo =
        _$_NavigationControllerBaseActionController.startAction(
            name: '_NavigationControllerBase.navigateToForgotPasswordPage');
    try {
      return super.navigateToForgotPasswordPage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToRegisterPage() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateToRegisterPage');
    try {
      return super.navigateToRegisterPage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToMainPage() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateToMainPage');
    try {
      return super.navigateToMainPage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToAdminPage() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateToAdminPage');
    try {
      return super.navigateToAdminPage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToProfilePage() {
    final _$actionInfo = _$_NavigationControllerBaseActionController
        .startAction(name: '_NavigationControllerBase.navigateToProfilePage');
    try {
      return super.navigateToProfilePage();
    } finally {
      _$_NavigationControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentRoute: ${currentRoute}
    ''';
  }
}
