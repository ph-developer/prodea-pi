import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../services/notification_service.dart';

class SendPasswordResetEmail {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;

  SendPasswordResetEmail(this._authRepo, this._notificationService);

  Future<bool> call(String email) async {
    try {
      if (email.isEmpty) {
        _notificationService
            .notifyError('O campo email não pode ficar em branco.');
        return false;
      }

      final result = await _authRepo.sendPasswordResetEmail(email);

      _notificationService.notifySuccess(
          'Solicitação de redefinição de senha enviada com sucesso.');

      return result;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return false;
    }
  }
}
