import '../../entities/user_info.dart';
import '../../repositories/user_info_repo.dart';

class GetDonorsInfo {
  final IUserInfoRepo _userInfoRepo;

  GetDonorsInfo(this._userInfoRepo);

  Stream<List<UserInfo>> call() {
    return _userInfoRepo.getUserInfos().map(_filterList).map(_orderList);
  }

  List<UserInfo> _filterList(List<UserInfo> list) {
    return list
        .where((userInfo) => userInfo.isDonor)
        .where((userInfo) => userInfo.status == AuthorizationStatus.authorized)
        .toList();
  }

  List<UserInfo> _orderList(List<UserInfo> list) {
    return list..sort((a, b) => a.name.compareTo(b.name));
  }
}
