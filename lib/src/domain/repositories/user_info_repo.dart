import '../entities/user_info.dart';

abstract class IUserInfoRepo {
  Future<UserInfo> getById(String id);
  Future<UserInfo> create(UserInfo userInfo);
  Future<UserInfo> update(UserInfo userInfo);
  Stream<List<UserInfo>> getUserInfos();
}
