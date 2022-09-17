import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../services/notification_service.dart';

class DoLogout {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;

  DoLogout(this._authRepo, this._notificationService);

  Future<bool> call() async {
    try {
      final result = await _authRepo.logout();

      return result;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return false;
    }
  }
}
