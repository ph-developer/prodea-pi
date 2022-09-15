import '../../../../core/helpers/notification.dart';
import '../../entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';

class DoLogin {
  final IAuthRepo _authRepo;

  DoLogin(this._authRepo);

  Future<User?> call(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        NotificationHelper.notifyError('Credenciais inválidas.');
        return null;
      }

      final loggedUser = await _authRepo.login(email, password);

      return loggedUser;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
