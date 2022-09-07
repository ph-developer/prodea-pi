import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';

class MyDonationsStore extends StreamStore<Error, List<Donation>> {
  final IDonationRepo donationRepo;

  MyDonationsStore(this.donationRepo) : super([]);

  void fetchData() {
    executeStream(donationRepo.myDonations());
  }

  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await donationRepo.getPhotoUrl(donation.photoUrl!);
  }

  Future<void> setDonationAsDelivered(Donation donation) async {
    await donationRepo.setAsDelivered(donation);
  }

  Future<void> setDonationAsCanceled(Donation donation, String reason) async {
    await donationRepo.setAsCanceled(donation, reason);
  }
}
