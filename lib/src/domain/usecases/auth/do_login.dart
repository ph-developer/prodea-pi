import '../../entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../services/notification_service.dart';

class DoLogin {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;

  DoLogin(this._authRepo, this._notificationService);

  Future<User?> call(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        _notificationService.notifyError('Credenciais inválidas.');
        return null;
      }

      final loggedUser = await _authRepo.login(email, password);

      return loggedUser;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
