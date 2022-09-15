import '../../entities/donation.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/donation_repo.dart';

class GetMyDonations {
  final IAuthRepo _authRepo;
  final IDonationRepo _donationRepo;

  GetMyDonations(this._authRepo, this._donationRepo);

  Stream<List<Donation>> call() {
    return _donationRepo.getDonations().asyncMap(_filterList).map(_orderList);
  }

  Future<List<Donation>> _filterList(List<Donation> list) async {
    final user = await _authRepo.getCurrentUser().first;
    if (user == null) return [];
    final donorId = user.id;

    return list.where((donation) => donation.donorId == donorId).toList();
  }

  List<Donation> _orderList(List<Donation> list) {
    return list..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }
}
