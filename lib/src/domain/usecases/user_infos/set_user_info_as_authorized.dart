import '../../../../core/errors/failures.dart';
import '../../dtos/user_info_dto.dart';
import '../../entities/user_info.dart';
import '../../repositories/user_info_repo.dart';
import '../../services/notification_service.dart';

class SetUserInfoAsAuthorized {
  final INotificationService _notificationService;
  final IUserInfoRepo _userInfoRepo;

  SetUserInfoAsAuthorized(this._userInfoRepo, this._notificationService);

  Future<UserInfo?> call(UserInfo userInfo) async {
    try {
      final newUserInfo = userInfo.copyWith(
        status: AuthorizationStatus.authorized,
      );

      final updatedUserInfo = await _userInfoRepo.update(newUserInfo);

      return updatedUserInfo;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
