// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthController on _AuthControllerBase, Store {
  Computed<bool>? _$isLoggedInComputed;

  @override
  bool get isLoggedIn =>
      (_$isLoggedInComputed ??= Computed<bool>(() => super.isLoggedIn,
              name: '_AuthControllerBase.isLoggedIn'))
          .value;
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??= Computed<bool>(() => super.isAdmin,
          name: '_AuthControllerBase.isAdmin'))
      .value;
  Computed<bool>? _$isDonorComputed;

  @override
  bool get isDonor => (_$isDonorComputed ??= Computed<bool>(() => super.isDonor,
          name: '_AuthControllerBase.isDonor'))
      .value;
  Computed<bool>? _$isBeneficiaryComputed;

  @override
  bool get isBeneficiary =>
      (_$isBeneficiaryComputed ??= Computed<bool>(() => super.isBeneficiary,
              name: '_AuthControllerBase.isBeneficiary'))
          .value;
  Computed<bool>? _$isAuthorizedComputed;

  @override
  bool get isAuthorized =>
      (_$isAuthorizedComputed ??= Computed<bool>(() => super.isAuthorized,
              name: '_AuthControllerBase.isAuthorized'))
          .value;
  Computed<bool>? _$isDeniedComputed;

  @override
  bool get isDenied =>
      (_$isDeniedComputed ??= Computed<bool>(() => super.isDenied,
              name: '_AuthControllerBase.isDenied'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: '_AuthControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$currentUserAtom =
      Atom(name: '_AuthControllerBase.currentUser', context: context);

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$fetchCurrentUserAsyncAction =
      AsyncAction('_AuthControllerBase.fetchCurrentUser', context: context);

  @override
  Future<void> fetchCurrentUser() {
    return _$fetchCurrentUserAsyncAction.run(() => super.fetchCurrentUser());
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthControllerBase.login', context: context);

  @override
  Future<void> login(String email, String password, {Function? onSuccess}) {
    return _$loginAsyncAction
        .run(() => super.login(email, password, onSuccess: onSuccess));
  }

  late final _$registerAsyncAction =
      AsyncAction('_AuthControllerBase.register', context: context);

  @override
  Future<void> register(String email, String password, User userInfo,
      {Function? onSuccess}) {
    return _$registerAsyncAction.run(
        () => super.register(email, password, userInfo, onSuccess: onSuccess));
  }

  late final _$sendPasswordResetEmailAsyncAction = AsyncAction(
      '_AuthControllerBase.sendPasswordResetEmail',
      context: context);

  @override
  Future<void> sendPasswordResetEmail(String email, {Function? onSuccess}) {
    return _$sendPasswordResetEmailAsyncAction
        .run(() => super.sendPasswordResetEmail(email, onSuccess: onSuccess));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthControllerBase.logout', context: context);

  @override
  Future<void> logout({Function? onSuccess}) {
    return _$logoutAsyncAction.run(() => super.logout(onSuccess: onSuccess));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentUser: ${currentUser},
isLoggedIn: ${isLoggedIn},
isAdmin: ${isAdmin},
isDonor: ${isDonor},
isBeneficiary: ${isBeneficiary},
isAuthorized: ${isAuthorized},
isDenied: ${isDenied}
    ''';
  }
}
