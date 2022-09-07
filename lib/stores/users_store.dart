import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';

class UsersStore extends StreamStore<Error, List<UserInfo>> {
  final IUserInfoRepo userInfoRepo;

  UsersStore(this.userInfoRepo) : super([]);

  void fetchData() {
    executeStream(userInfoRepo.usersInfo());
  }

  UserInfo getUserById(String id) {
    return state.firstWhere((userInfo) => userInfo.id == id);
  }
}
