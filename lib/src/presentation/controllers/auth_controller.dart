// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_info.dart';
import '../../../core/errors/failures.dart';
import '../../../core/helpers/navigation.dart';
import '../../../core/helpers/notification.dart';
import '../../domain/usecases/auth/do_login.dart';
import '../../domain/usecases/auth/do_logout.dart';
import '../../domain/usecases/auth/do_register.dart';
import '../../domain/usecases/auth/get_current_user.dart';
import '../../domain/usecases/auth/send_password_reset_email.dart';
import '../../domain/usecases/user_infos/get_user_info_by_id.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  final GetCurrentUser _getCurrentUser;
  final GetUserInfoById _getUserInfoById;
  final DoLogin _doLogin;
  final DoRegister _doRegister;
  final DoLogout _doLogout;
  final SendPasswordResetEmail _sendPasswordResetEmail;

  _AuthControllerBase(
    this._getCurrentUser,
    this._getUserInfoById,
    this._doLogin,
    this._doRegister,
    this._doLogout,
    this._sendPasswordResetEmail,
  );

  @observable
  bool isLoading = false;

  @observable
  User? currentUser;

  @observable
  UserInfo? currentUserInfo;

  @computed
  bool get isLoggedIn => currentUser != null;

  @computed
  bool get isAdmin => currentUserInfo?.isAdmin == true;

  @computed
  bool get isDonor => currentUserInfo?.isDonor == true;

  @computed
  bool get isBeneficiary => currentUserInfo?.isBeneficiary == true;

  @computed
  bool get isAuthorized =>
      currentUserInfo?.status == AuthorizationStatus.authorized;

  @computed
  bool get isDenied => currentUserInfo?.status == AuthorizationStatus.denied;

  @action
  void init({Function? afterLoginCallback, Function? afterNavigationCallback}) {
    _getCurrentUser().listen((user) async {
      if (user != null) {
        try {
          final userInfo = await _getUserInfoById(user.id);
          currentUser = user;
          currentUserInfo = userInfo;
          afterLoginCallback?.call();
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
        } on Failure catch (failure) {
          NotificationHelper.notifyError(failure.message);
        }
      } else {
        currentUser = null;
        currentUserInfo = null;
        NavigationHelper.goTo('/login', replace: true);
      }
      isLoading = false;
      afterNavigationCallback?.call();
    });
  }

  @action
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      await _doLogin(email, password);
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      isLoading = false;
    }
  }

  @action
  Future<void> register(
    String email,
    String password,
    UserInfo userInfo,
  ) async {
    try {
      isLoading = true;
      await _doRegister(email, password, userInfo);
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      await logout();
      isLoading = false;
    }
  }

  @action
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading = true;
      await _sendPasswordResetEmail(email);

      NavigationHelper.goTo('/login', replace: true);
      NotificationHelper.notifySuccess(
          'Solicitação de redefinição de senha enviada com sucesso.');
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
    }
    isLoading = false;
  }

  @action
  Future<void> logout() async {
    try {
      isLoading = true;
      await _doLogout();
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
    }
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
