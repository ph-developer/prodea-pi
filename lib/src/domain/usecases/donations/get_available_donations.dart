import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../repositories/donation_repo.dart';

class GetAvailableDonations {
  final IDonationRepo _donationRepo;

  GetAvailableDonations(this._donationRepo);

  Stream<List<Donation>> call() {
    return _donationRepo.getDonations().map(_filterList).map(_orderList);
  }

  List<Donation> _filterList(List<Donation> list) {
    return list
        .where((donation) => donation.beneficiaryId == null)
        .where((donation) => donation.cancellation == null)
        .where((donation) => !donation.isExpired)
        .toList();
  }

  List<Donation> _orderList(List<Donation> list) {
    return list..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }
}
