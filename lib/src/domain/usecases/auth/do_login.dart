import '../../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_repo.dart';
import '../../services/notification_service.dart';

class DoLogin {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  DoLogin(this._authRepo, this._notificationService, this._userRepo);

  Future<User?> call(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        _notificationService.notifyError('Credenciais inválidas.');
        return null;
      }

      final userId = await _authRepo.login(email, password);
      final user = await _userRepo.getById(userId);

      return user;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
