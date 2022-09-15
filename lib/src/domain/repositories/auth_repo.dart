import '../entities/user.dart';

abstract class IAuthRepo {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
  Future<bool> logout();
  Stream<User?> getCurrentUser();
}
