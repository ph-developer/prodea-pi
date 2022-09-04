import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/user.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/services/contracts/navigation_service.dart';

class AuthStore extends NotifierStore<Exception, AuthState> {
  final IAuthRepo authRepo;
  final IUserInfoRepo userInfoRepo;
  final INavigationService navigationService;

  AuthStore(
    this.authRepo,
    this.userInfoRepo,
    this.navigationService,
  ) : super(AuthState());

  bool get isLoggedIn => state.currentUser != null;

  bool get isAdmin => state.currentUserInfo?.isAdmin == true;
  bool get isDonor => state.currentUserInfo?.isDonor == true;
  bool get isBeneficiary => state.currentUserInfo?.isBeneficiary == true;

  bool get isAuthorized =>
      state.currentUserInfo?.status == AuthorizationStatus.authorized;
  bool get isDenied =>
      state.currentUserInfo?.status == AuthorizationStatus.denied;

  void fetchUser() {
    authRepo.authStateChanged().listen((user) async {
      if (user != null) {
        final userInfo = await userInfoRepo.getCurrentUserInfo();
        update(AuthState(currentUser: user, currentUserInfo: userInfo));
        navigationService.navigate('/home', replace: true);
      } else {
        update(AuthState());
        navigationService.navigate('/login', replace: true);
      }
    });
  }

  Future<void> login(String email, String password) async {
    await authRepo.login(email, password);
  }

  Future<void> logout() async {
    await authRepo.logout();
  }
}

class AuthState {
  final User? currentUser;
  final UserInfo? currentUserInfo;

  AuthState({
    this.currentUser,
    this.currentUserInfo,
  });
}
