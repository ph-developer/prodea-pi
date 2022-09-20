abstract class IAuthRepo {
  Future<String> login(String email, String password);
  Future<String> register(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
  Future<bool> logout();
  Future<String?> getCurrentUserId();
  Stream<String?> currentUserIdChanged();
}
