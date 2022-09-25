// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../domain/entities/donation.dart';
import '../../domain/usecases/donations/get_available_donations.dart';
import '../../domain/usecases/donations/get_donation_photo_url.dart';
import '../../domain/usecases/donations/get_my_donations.dart';
import '../../domain/usecases/donations/get_requested_donations.dart';
import '../../domain/usecases/donations/set_donation_as_canceled.dart';
import '../../domain/usecases/donations/set_donation_as_delivered.dart';
import '../../domain/usecases/donations/set_donation_as_requested.dart';
import '../../domain/usecases/donations/set_donation_as_unrequested.dart';

part 'donations_store.g.dart';

class DonationsStore = _DonationsStoreBase with _$DonationsStore;

abstract class _DonationsStoreBase with Store {
  final GetRequestedDonations _getRequestedDonations;
  final GetAvailableDonations _getAvailableDonations;
  final GetMyDonations _getMyDonations;
  final SetDonationAsDelivered _setDonationAsDelivered;
  final SetDonationAsRequested _setDonationAsRequested;
  final SetDonationAsUnrequested _setDonationAsUnrequested;
  final SetDonationAsCanceled _setDonationAsCanceled;
  final GetDonationPhotoUrl _getDonationPhotoUrl;
  final List<StreamSubscription> _subscriptions = [];

  _DonationsStoreBase(
    this._getRequestedDonations,
    this._getAvailableDonations,
    this._getMyDonations,
    this._setDonationAsDelivered,
    this._setDonationAsRequested,
    this._setDonationAsUnrequested,
    this._setDonationAsCanceled,
    this._getDonationPhotoUrl,
  ) {
    init();
  }

  @observable
  ObservableList<Donation> requestedDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> availableDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> myDonations = ObservableList.of([]);

  @action
  void init() {
    _subscriptions.map((subscription) => subscription.cancel());
    _subscriptions.clear();

    _subscriptions.addAll([
      _getRequestedDonations().listen((list) {
        requestedDonations = list.asObservable();
      }),
      _getAvailableDonations().listen((list) {
        availableDonations = list.asObservable();
      }),
      _getMyDonations().listen((list) {
        myDonations = list.asObservable();
      }),
    ]);
  }

  @action
  Future<String?> getDonationPhotoURL(Donation donation) async {
    if (donation.photoUrl == null) return null;
    return await _getDonationPhotoUrl(donation);
  }

  @action
  Future<void> setDonationAsDelivered(Donation donation) async {
    await _setDonationAsDelivered(donation);
  }

  @action
  Future<void> setDonationAsRequested(Donation donation) async {
    await _setDonationAsRequested(donation);
  }

  @action
  Future<void> setDonationAsUnrequested(Donation donation) async {
    await _setDonationAsUnrequested(donation);
  }

  @action
  Future<void> setDonationAsCanceled(Donation donation, String reason) async {
    await _setDonationAsCanceled(donation, reason);
  }
}
