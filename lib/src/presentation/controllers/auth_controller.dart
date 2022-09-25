// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/entities/user.dart';
import '../../../core/helpers/navigation.dart';
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
  ) {
    init();
  }

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
  Future<bool> isReady() async {
    await _getCurrentUser().first;
    return true;
  }

  @action
  void init() {
    _getCurrentUser().listen((user) async {
      if (user != null) {
        currentUser = user;
        navigateToInitialRoute();
      } else {
        currentUser = null;
        NavigationHelper.goTo('/login', replace: true);
      }
      isLoading = false;
    });
  }

  @action
  void navigateToInitialRoute() {
    if (isAuthorized) {
      if (isDonor) {
        NavigationHelper.goTo('/main/donate', replace: true);
      } else if (isBeneficiary) {
        NavigationHelper.goTo('/main/available-donations', replace: true);
      }
    } else if (isDenied) {
      NavigationHelper.goTo('/denied', replace: true);
    } else {
      NavigationHelper.goTo('/waiting', replace: true);
    }
  }

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    await _doLogin(email, password);
    isLoading = false;
  }

  @action
  Future<void> register(String email, String password, User userInfo) async {
    isLoading = true;
    await _doRegister(email, password, userInfo);
    isLoading = false;
  }

  @action
  Future<void> sendPasswordResetEmail(String email) async {
    isLoading = true;
    final result = await _sendPasswordResetEmail(email);
    if (result) NavigationHelper.goTo('/login', replace: true);
    isLoading = false;
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    await _doLogout();
    isLoading = false;
  }

  @action
  void navigateToLoginPage() {
    NavigationHelper.goTo('/login', replace: true);
  }

  @action
  void navigateToForgotPasswordPage() {
    NavigationHelper.goTo('/forgot', replace: true);
  }

  @action
  void navigateToRegisterPage() {
    NavigationHelper.goTo('/register', replace: true);
  }
}
