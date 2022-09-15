import '../../../../core/helpers/notification.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';

class SendPasswordResetEmail {
  final IAuthRepo _authRepo;

  SendPasswordResetEmail(this._authRepo);

  Future<bool> call(String email) async {
    try {
      // TODO validate fields

      final result = await _authRepo.sendPasswordResetEmail(email);

      return result;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return false;
    }
  }
}
