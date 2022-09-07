import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';

class BeneficiariesStore extends StreamStore<Error, List<UserInfo>> {
  final IUserInfoRepo userInfoRepo;

  BeneficiariesStore(this.userInfoRepo) : super([]);

  void fetchData() {
    executeStream(userInfoRepo.beneficiariesInfo());
  }

  UserInfo getBeneficiaryById(String id) {
    return state.firstWhere((userInfo) => userInfo.id == id);
  }
}
