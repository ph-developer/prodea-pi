import '../entities/user.dart';

abstract class IUserRepo {
  Future<User> getById(String id);
  Future<User> create(User user);
  Future<User> update(User user);
  Stream<List<User>> getUsers();
}
