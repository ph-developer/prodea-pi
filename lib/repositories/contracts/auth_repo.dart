import 'package:prodea/models/user.dart';
import 'package:prodea/models/user_info.dart';

abstract class IAuthRepo {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, UserInfo userInfo);
  Future<void> logout();
  Stream<User?> authStateChanged();
}
