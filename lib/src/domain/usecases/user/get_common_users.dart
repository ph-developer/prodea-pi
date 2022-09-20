import '../../entities/user.dart';
import '../../repositories/user_repo.dart';

class GetCommonUsers {
  final IUserRepo _userRepo;

  GetCommonUsers(this._userRepo);

  Stream<List<User>> call() {
    return _userRepo.getUsers().map(_filterList).map(_orderList);
  }

  List<User> _filterList(List<User> list) {
    return list.where((user) => !user.isAdmin).toList();
  }

  List<User> _orderList(List<User> list) {
    return list..sort((a, b) => a.name.compareTo(b.name));
  }
}
