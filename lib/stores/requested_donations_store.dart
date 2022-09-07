import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';

class RequestedDonationsStore extends StreamStore<Error, List<Donation>> {
  final IDonationRepo donationRepo;

  RequestedDonationsStore(this.donationRepo) : super([]);

  void fetchData() {
    executeStream(donationRepo.requestedDonations());
  }

  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await donationRepo.getPhotoUrl(donation.photoUrl!);
  }

  Future<void> setDonationAsDelivered(Donation donation) async {
    await donationRepo.setAsDelivered(donation);
  }

  Future<void> setDonationAsUnrequested(Donation donation) async {
    await donationRepo.setAsUnrequested(donation);
  }
}
