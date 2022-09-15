import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../entities/user_info.dart';
import '../../repositories/user_info_repo.dart';

class GetUserInfoById {
  final IUserInfoRepo _userInfoRepo;

  GetUserInfoById(this._userInfoRepo);

  Future<UserInfo?> call(String id) async {
    try {
      final userInfo = await _userInfoRepo.getById(id);

      return userInfo;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
