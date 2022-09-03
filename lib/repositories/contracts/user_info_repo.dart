import 'package:prodea/models/user_info.dart';

abstract class IUserInfoRepo {
  Stream<List<UserInfo>> donorsInfo();
  Stream<List<UserInfo>> beneficiariesInfo();
  Stream<List<UserInfo>> usersInfo();
  Future<UserInfo?> getCurrentUserInfo();
  Future<UserInfo?> create(UserInfo userInfo);
  Future<void> setStatus(UserInfo userInfo, AuthorizationStatus status);
}
