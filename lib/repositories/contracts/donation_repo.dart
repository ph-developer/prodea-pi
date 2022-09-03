import 'dart:io';

import 'package:prodea/models/donation.dart';

abstract class IDonationRepo {
  Future<String?> uploadPhoto(File file);
  Future<String> getPhotoUrl(String path);
  Future<Donation?> create(Donation donation);
  Future<void> setAsDelivered(Donation donation);
  Future<void> setAsCanceled(Donation donation, String reason);
  Future<void> setAsRequested(Donation donation);
  Future<void> setAsUnrequested(Donation donation);
  Stream<List<Donation>> availableDonations();
  Stream<List<Donation>> myDonations();
  Stream<List<Donation>> receivedDonations();
}
