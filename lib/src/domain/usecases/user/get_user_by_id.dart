import '../../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_repo.dart';
import '../../services/notification_service.dart';

class GetUserById {
  final INotificationService _notificationService;
  final IUserRepo _userRepo;

  GetUserById(this._userRepo, this._notificationService);

  Future<User?> call(String id) async {
    try {
      final user = await _userRepo.getById(id);

      return user;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
