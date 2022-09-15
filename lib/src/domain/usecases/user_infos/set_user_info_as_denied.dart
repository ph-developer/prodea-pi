import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../dtos/user_info_dto.dart';
import '../../entities/user_info.dart';
import '../../repositories/user_info_repo.dart';

class SetUserInfoAsDenied {
  final IUserInfoRepo _userInfoRepo;

  SetUserInfoAsDenied(this._userInfoRepo);

  Future<UserInfo?> call(UserInfo userInfo) async {
    try {
      final newUserInfo = userInfo.copyWith(
        status: AuthorizationStatus.denied,
      );

      final updatedUserInfo = await _userInfoRepo.update(newUserInfo);

      return updatedUserInfo;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
