import '../../../../core/errors/failures.dart';
import '../../dtos/user_dto.dart';
import '../../entities/user.dart';
import '../../repositories/user_repo.dart';
import '../../services/notification_service.dart';

class SetUserAsDenied {
  final INotificationService _notificationService;
  final IUserRepo _userRepo;

  SetUserAsDenied(this._userRepo, this._notificationService);

  Future<User?> call(User user) async {
    try {
      final newUser = user.copyWith(
        status: AuthorizationStatus.denied,
      );

      final updatedUser = await _userRepo.update(newUser);

      return updatedUser;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
