import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';

part 'donations_store.g.dart';

class DonationsStore = _DonationsStoreBase with _$DonationsStore;

abstract class _DonationsStoreBase with Store {
  final IDonationRepo donationRepo;
  final List<StreamSubscription> _subscriptions = [];

  _DonationsStoreBase(this.donationRepo);

  @observable
  ObservableList<Donation> requestedDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> availableDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> myDonations = ObservableList.of([]);

  @action
  void init() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    final subRequested = donationRepo.requestedDonations().listen((donations) {
      requestedDonations = donations.asObservable();
    });
    _subscriptions.add(subRequested);

    final subAvailable = donationRepo.availableDonations().listen((donations) {
      availableDonations = donations.asObservable();
    });
    _subscriptions.add(subAvailable);

    final subMy = donationRepo.myDonations().listen((donations) {
      myDonations = donations.asObservable();
    });
    _subscriptions.add(subMy);
  }

  @action
  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await donationRepo.getPhotoUrl(donation.photoUrl!);
  }

  @action
  Future<void> setDonationAsDelivered(Donation donation) async {
    await donationRepo.setAsDelivered(donation);
  }

  @action
  Future<void> setDonationAsRequested(Donation donation) async {
    await donationRepo.setAsRequested(donation);
  }

  @action
  Future<void> setDonationAsUnrequested(Donation donation) async {
    await donationRepo.setAsUnrequested(donation);
  }

  @action
  Future<void> setDonationAsCanceled(Donation donation, String reason) async {
    await donationRepo.setAsCanceled(donation, reason);
  }
}
