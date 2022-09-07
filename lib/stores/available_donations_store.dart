import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';

class AvailableDonationsStore extends StreamStore<Error, List<Donation>> {
  final IDonationRepo donationRepo;

  AvailableDonationsStore(this.donationRepo) : super([]);

  void fetchData() {
    executeStream(donationRepo.availableDonations());
  }

  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await donationRepo.getPhotoUrl(donation.photoUrl!);
  }

  Future<void> setDonationAsRequested(Donation donation) async {
    await donationRepo.setAsRequested(donation);
  }
}
