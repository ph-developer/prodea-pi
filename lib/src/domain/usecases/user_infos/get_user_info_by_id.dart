import '../../../../core/errors/failures.dart';
import '../../entities/user_info.dart';
import '../../repositories/user_info_repo.dart';
import '../../services/notification_service.dart';

class GetUserInfoById {
  final INotificationService _notificationService;
  final IUserInfoRepo _userInfoRepo;

  GetUserInfoById(this._userInfoRepo, this._notificationService);

  Future<UserInfo?> call(String id) async {
    try {
      final userInfo = await _userInfoRepo.getById(id);

      return userInfo;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
