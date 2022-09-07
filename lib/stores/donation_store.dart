import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';

part 'donation_store.g.dart';

class DonationStore = _DonationStoreBase with _$DonationStore;

abstract class _DonationStoreBase with Store {
  final IDonationRepo donationRepo;
  final INotificationService notificationService;

  _DonationStoreBase(
    this.donationRepo,
    this.notificationService,
  );

  @observable
  String description = '';

  @observable
  File? image;

  @observable
  String? beneficiaryId;

  @observable
  String expiration = '';

  @action
  Future<void> postDonation() async {
    String? photoUrl;

    if (image != null) {
      photoUrl = await donationRepo.uploadPhoto(image!);
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
