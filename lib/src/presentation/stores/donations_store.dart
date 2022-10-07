// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../core/mixins/stream_subscriber.dart';
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

abstract class _DonationsStoreBase with Store, StreamSubscriber {
  final GetRequestedDonations _getRequestedDonations;
  final GetAvailableDonations _getAvailableDonations;
  final GetMyDonations _getMyDonations;
  final SetDonationAsDelivered _setDonationAsDelivered;
  final SetDonationAsRequested _setDonationAsRequested;
  final SetDonationAsUnrequested _setDonationAsUnrequested;
  final SetDonationAsCanceled _setDonationAsCanceled;
  final GetDonationPhotoUrl _getDonationPhotoUrl;

  _DonationsStoreBase(
    this._getRequestedDonations,
    this._getAvailableDonations,
    this._getMyDonations,
    this._setDonationAsDelivered,
    this._setDonationAsRequested,
    this._setDonationAsUnrequested,
    this._setDonationAsCanceled,
    this._getDonationPhotoUrl,
  );

  @observable
  ObservableList<Donation> requestedDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> availableDonations = ObservableList.of([]);

  @observable
  ObservableList<Donation> myDonations = ObservableList.of([]);

  @action
  Future<void> fetchDonations() async {
    await unsubscribeAll();
    await subscribe(_getRequestedDonations(), (list) {
      requestedDonations = list.asObservable();
    });
    await subscribe(_getAvailableDonations(), (list) {
      availableDonations = list.asObservable();
    });
    await subscribe(_getMyDonations(), (list) {
      myDonations = list.asObservable();
    });
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
