// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:prodea/models/user.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/services/contracts/navigation_service.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  final IAuthRepo authRepo;
  final IUserInfoRepo userInfoRepo;
  final INavigationService navigationService;

  _AuthControllerBase(
    this.authRepo,
    this.userInfoRepo,
    this.navigationService,
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
    authRepo.authStateChanged().listen((user) async {
      if (user != null) {
        final userInfo = await userInfoRepo.getCurrentUserInfo();
        currentUser = user;
        currentUserInfo = userInfo;
        if (afterLoginCallback != null) afterLoginCallback();
        if (isAuthorized) {
          navigationService.navigate('/home', replace: true);
        } else if (isDenied) {
          navigationService.navigate('/denied', replace: true);
        } else {
          navigationService.navigate('/waiting', replace: true);
        }
      } else {
        currentUser = null;
        currentUserInfo = null;
        navigationService.navigate('/login', replace: true);
      }
      isLoading = false;
      if (afterNavigationCallback != null) afterNavigationCallback();
    });
  }

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    final result = await authRepo.login(email.trim(), password);
    if (!result) isLoading = false;
  }

  @action
  Future<void> logout() async {
    await authRepo.logout();
  }
}
