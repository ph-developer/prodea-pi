import '../../../../core/helpers/notification.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';

class DoLogout {
  final IAuthRepo _authRepo;

  DoLogout(this._authRepo);

  Future<bool> call() async {
    try {
      final result = await _authRepo.logout();

      return result;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return false;
    }
  }
}
