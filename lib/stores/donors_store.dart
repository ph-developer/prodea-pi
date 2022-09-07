import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';

class DonorsStore extends StreamStore<Error, List<UserInfo>> {
  final IUserInfoRepo userInfoRepo;

  DonorsStore(this.userInfoRepo) : super([]);

  void fetchData() {
    executeStream(userInfoRepo.donorsInfo());
  }

  UserInfo getDonorById(String id) {
    return state.firstWhere((userInfo) => userInfo.id == id);
  }
}
