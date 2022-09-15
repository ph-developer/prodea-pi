import '../../entities/user.dart';
import '../../repositories/auth_repo.dart';

class GetCurrentUser {
  final IAuthRepo _authRepo;

  GetCurrentUser(this._authRepo);

  Stream<User?> call() {
    return _authRepo.getCurrentUser();
  }
}
