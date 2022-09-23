import '../../entities/donation.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/donation_repo.dart';

class GetRequestedDonations {
  final IAuthRepo _authRepo;
  final IDonationRepo _donationRepo;

  GetRequestedDonations(this._authRepo, this._donationRepo);

  Stream<List<Donation>> call() {
    return _donationRepo
        .getDonations()
        .asBroadcastStream()
        .asyncMap(_filterList)
        .map(_orderList);
  }

  Future<List<Donation>> _filterList(List<Donation> list) async {
    final beneficiaryId = await _authRepo.getCurrentUserId();

    if (beneficiaryId == null) return [];

    return list
        .where((donation) => donation.beneficiaryId == beneficiaryId)
        .toList();
  }

  List<Donation> _orderList(List<Donation> list) {
    return list..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }
}
