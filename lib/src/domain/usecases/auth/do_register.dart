import '../../dtos/user_info_dto.dart';
import '../../entities/user.dart';
import '../../entities/user_info.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_info_repo.dart';
import '../../services/notification_service.dart';

class DoRegister {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;
  final IUserInfoRepo _userInfoRepo;

  DoRegister(this._authRepo, this._userInfoRepo, this._notificationService);

  Future<User?> call(String email, String password, UserInfo userInfo) async {
    try {
      // TODO validate fields

      final loggedUser = await _authRepo.register(email, password);

      final userId = loggedUser.id;

      var newUserInfo = userInfo.copyWith(
        id: userId,
      );

      await _userInfoRepo.create(newUserInfo);

      return loggedUser;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
