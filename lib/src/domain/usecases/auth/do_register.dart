import '../../dtos/user_dto.dart';
import '../../entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_repo.dart';
import '../../services/notification_service.dart';

class DoRegister {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  DoRegister(this._authRepo, this._userRepo, this._notificationService);

  Future<User?> call(String email, String password, User userData) async {
    try {
      // TODO validate fields

      final loggedUser = await _authRepo.register(email, password);

      final userId = loggedUser;

      var newUserData = userData.copyWith(
        id: userId,
      );

      final user = await _userRepo.create(newUserData);

      return user;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
