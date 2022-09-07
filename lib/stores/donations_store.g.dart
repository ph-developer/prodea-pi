// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DonationsStore on _DonationsStoreBase, Store {
  late final _$requestedDonationsAtom =
      Atom(name: '_DonationsStoreBase.requestedDonations', context: context);

  @override
  ObservableList<Donation> get requestedDonations {
    _$requestedDonationsAtom.reportRead();
    return super.requestedDonations;
  }

  @override
  set requestedDonations(ObservableList<Donation> value) {
    _$requestedDonationsAtom.reportWrite(value, super.requestedDonations, () {
      super.requestedDonations = value;
    });
  }

  late final _$availableDonationsAtom =
      Atom(name: '_DonationsStoreBase.availableDonations', context: context);

  @override
  ObservableList<Donation> get availableDonations {
    _$availableDonationsAtom.reportRead();
    return super.availableDonations;
  }

  @override
  set availableDonations(ObservableList<Donation> value) {
    _$availableDonationsAtom.reportWrite(value, super.availableDonations, () {
      super.availableDonations = value;
    });
  }

  late final _$myDonationsAtom =
      Atom(name: '_DonationsStoreBase.myDonations', context: context);

  @override
  ObservableList<Donation> get myDonations {
    _$myDonationsAtom.reportRead();
    return super.myDonations;
  }

  @override
  set myDonations(ObservableList<Donation> value) {
    _$myDonationsAtom.reportWrite(value, super.myDonations, () {
      super.myDonations = value;
    });
  }

  late final _$getDonationPhotoURLAsyncAction =
      AsyncAction('_DonationsStoreBase.getDonationPhotoURL', context: context);

  @override
  Future<String?> getDonationPhotoURL(Donation donation) {
    return _$getDonationPhotoURLAsyncAction
        .run(() => super.getDonationPhotoURL(donation));
  }

  late final _$setDonationAsDeliveredAsyncAction = AsyncAction(
      '_DonationsStoreBase.setDonationAsDelivered',
      context: context);

  @override
  Future<void> setDonationAsDelivered(Donation donation) {
    return _$setDonationAsDeliveredAsyncAction
        .run(() => super.setDonationAsDelivered(donation));
  }

  late final _$setDonationAsRequestedAsyncAction = AsyncAction(
      '_DonationsStoreBase.setDonationAsRequested',
      context: context);

  @override
  Future<void> setDonationAsRequested(Donation donation) {
    return _$setDonationAsRequestedAsyncAction
        .run(() => super.setDonationAsRequested(donation));
  }

  late final _$setDonationAsUnrequestedAsyncAction = AsyncAction(
      '_DonationsStoreBase.setDonationAsUnrequested',
      context: context);

  @override
  Future<void> setDonationAsUnrequested(Donation donation) {
    return _$setDonationAsUnrequestedAsyncAction
        .run(() => super.setDonationAsUnrequested(donation));
  }

  late final _$setDonationAsCanceledAsyncAction = AsyncAction(
      '_DonationsStoreBase.setDonationAsCanceled',
      context: context);

  @override
  Future<void> setDonationAsCanceled(Donation donation, String reason) {
    return _$setDonationAsCanceledAsyncAction
        .run(() => super.setDonationAsCanceled(donation, reason));
  }

  late final _$_DonationsStoreBaseActionController =
      ActionController(name: '_DonationsStoreBase', context: context);

  @override
  void init() {
    final _$actionInfo = _$_DonationsStoreBaseActionController.startAction(
        name: '_DonationsStoreBase.init');
    try {
      return super.init();
    } finally {
      _$_DonationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requestedDonations: ${requestedDonations},
availableDonations: ${availableDonations},
myDonations: ${myDonations}
    ''';
  }
}
