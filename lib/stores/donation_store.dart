// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/services/contracts/navigation_service.dart';
import 'package:prodea/services/contracts/notification_service.dart';

part 'donation_store.g.dart';

class DonationStore = _DonationStoreBase with _$DonationStore;

abstract class _DonationStoreBase with Store {
  final IDonationRepo donationRepo;
  final INotificationService notificationService;
  final INavigationService navigationService;

  _DonationStoreBase(
    this.donationRepo,
    this.notificationService,
    this.navigationService,
  );

  @observable
  bool isLoading = false;

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
    isLoading = true;

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
      navigationService.navigate(
        '/main',
        replace: true,
        params: {'pageIndex': 1},
      );
    }

    isLoading = false;
  }
}
