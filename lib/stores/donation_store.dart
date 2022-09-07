import 'dart:io';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';

class DonationStore extends NotifierStore<Exception, int> {
  final IDonationRepo donationRepo;
  final INotificationService notificationService;

  DonationStore(
    this.donationRepo,
    this.notificationService,
  ) : super(0);

  Future<void> postDonation(
    String description,
    File? image,
    String? beneficiaryId,
    String expiration,
  ) async {
    String? photoUrl;

    if (image != null) {
      photoUrl = await donationRepo.uploadPhoto(image);
    }

    final donation = Donation(
      description: description,
      photoUrl: photoUrl,
      beneficiaryId: beneficiaryId,
      expiration: expiration,
      cancellation: null,
      isDelivered: false,
      createdAt: DateTime.now(),
    );

    final result = await donationRepo.create(donation);

    if (result != null) {
      notificationService.notifySuccess('Doação postada com sucesso.');
      // TODO navigate to minhas doações
    }
  }
}
