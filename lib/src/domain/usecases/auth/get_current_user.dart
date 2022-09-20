import '../../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_repo.dart';
import '../../services/notification_service.dart';

class GetCurrentUser {
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;
  final INotificationService _notificationService;

  GetCurrentUser(this._authRepo, this._userRepo, this._notificationService);

  Stream<User?> call() {
    return _authRepo.currentUserIdChanged().asyncMap((userId) async {
      if (userId == null) return null;

      try {
        final user = await _userRepo.getById(userId);

        return user;
      } on Failure catch (failure) {
        _notificationService.notifyError(failure.message);
        return null;
      }
    });
  }
}
