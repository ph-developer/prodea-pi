import '../../entities/user.dart';
import '../../repositories/user_repo.dart';

class GetDonors {
  final IUserRepo _userRepo;

  GetDonors(this._userRepo);

  Stream<List<User>> call() {
    return _userRepo.getUsers().map(_filterList).map(_orderList);
  }

  List<User> _filterList(List<User> list) {
    return list
        .where((user) => user.isDonor)
        .where((user) => user.status == AuthorizationStatus.authorized)
        .toList();
  }

  List<User> _orderList(List<User> list) {
    return list..sort((a, b) => a.name.compareTo(b.name));
  }
}
