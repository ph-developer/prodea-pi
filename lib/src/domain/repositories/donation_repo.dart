import '../entities/donation.dart';

abstract class IDonationRepo {
  Future<Donation> create(Donation donation);
  Future<Donation> update(Donation donation);
  Stream<List<Donation>> getDonations();
}
