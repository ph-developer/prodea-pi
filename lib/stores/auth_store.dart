import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/user.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';

bool _isFirstLoad = true;

class AuthStore extends NotifierStore<Exception, AuthState> {
  final IAuthRepo authRepo;
  final IUserInfoRepo userInfoRepo;

  AuthStore(
    this.authRepo,
    this.userInfoRepo,
  ) : super(AuthState());

  bool get isLoggedIn => state.currentUser != null;

  bool get isAdmin => state.currentUserInfo?.isAdmin == true;
  bool get isDonor => state.currentUserInfo?.isDonor == true;
  bool get isBeneficiary => state.currentUserInfo?.isBeneficiary == true;

  bool get isAuthorized =>
      state.currentUserInfo?.status == AuthorizationStatus.authorized;
  bool get isDenied =>
      state.currentUserInfo?.status == AuthorizationStatus.denied;

  Future<void> fetchUser(Function afterFirstLoad) async {
    authRepo.authStateChanged().listen((user) async {
      if (user != null) {
        final userInfo = await userInfoRepo.getCurrentUserInfo();
        update(AuthState(currentUser: user, currentUserInfo: userInfo));
      } else {
        update(AuthState());
      }

      if (_isFirstLoad) {
        afterFirstLoad();
        _isFirstLoad = false;
      }

      // TODO navigate
    });
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
