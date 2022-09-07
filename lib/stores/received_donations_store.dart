import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';

class ReceivedDonationsStore extends StreamStore<Error, List<Donation>> {
  final IDonationRepo donationRepo;

  ReceivedDonationsStore(this.donationRepo) : super([]);

  void fetchData() {
    executeStream(donationRepo.receivedDonations());
  }

  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await donationRepo.getPhotoUrl(donation.photoUrl!);
  }
}
