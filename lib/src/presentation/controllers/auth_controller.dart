// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/auth/do_login.dart';
import '../../domain/usecases/auth/do_logout.dart';
import '../../domain/usecases/auth/do_register.dart';
import '../../domain/usecases/auth/get_current_user.dart';
import '../../domain/usecases/auth/send_password_reset_email.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  final GetCurrentUser _getCurrentUser;
  final DoLogin _doLogin;
  final DoRegister _doRegister;
  final DoLogout _doLogout;
  final SendPasswordResetEmail _sendPasswordResetEmail;

  _AuthControllerBase(
    this._getCurrentUser,
    this._doLogin,
    this._doRegister,
    this._doLogout,
    this._sendPasswordResetEmail,
  );

  @observable
  bool isLoading = false;

  @observable
  User? currentUser;

  @computed
  bool get isLoggedIn => currentUser != null;

  @computed
  bool get isAdmin => currentUser?.isAdmin == true;

  @computed
  bool get isDonor => currentUser?.isDonor == true;

  @computed
  bool get isBeneficiary => currentUser?.isBeneficiary == true;

  @computed
  bool get isAuthorized =>
      currentUser?.status == AuthorizationStatus.authorized;

  @computed
  bool get isDenied => currentUser?.status == AuthorizationStatus.denied;

  @action
  Future<void> fetchCurrentUser() async {
    currentUser = await _getCurrentUser();
  }

  @action
  Future<void> login(
    String email,
    String password, {
    Function? onSuccess,
  }) async {
    isLoading = true;
    currentUser = await _doLogin(email, password);
    if (isLoggedIn) onSuccess?.call();
    isLoading = false;
  }

  @action
  Future<void> register(
    String email,
    String password,
    User userInfo, {
    Function? onSuccess,
  }) async {
    isLoading = true;
    currentUser = await _doRegister(email, password, userInfo);
    if (isLoggedIn) onSuccess?.call();
    isLoading = false;
  }

  @action
  Future<void> sendPasswordResetEmail(
    String email, {
    Function? onSuccess,
  }) async {
    isLoading = true;
    final result = await _sendPasswordResetEmail(email);
    if (result) onSuccess?.call();
    isLoading = false;
  }

  @action
  Future<void> logout({Function? onSuccess}) async {
    isLoading = true;
    final result = await _doLogout();
    if (result) {
      currentUser = null;
      onSuccess?.call();
    }
    isLoading = false;
  }
}
