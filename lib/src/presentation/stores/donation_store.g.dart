// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DonationStore on _DonationStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_DonationStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: '_DonationStoreBase.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$imageAtom =
      Atom(name: '_DonationStoreBase.image', context: context);

  @override
  File? get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(File? value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  late final _$beneficiaryIdAtom =
      Atom(name: '_DonationStoreBase.beneficiaryId', context: context);

  @override
  String? get beneficiaryId {
    _$beneficiaryIdAtom.reportRead();
    return super.beneficiaryId;
  }

  @override
  set beneficiaryId(String? value) {
    _$beneficiaryIdAtom.reportWrite(value, super.beneficiaryId, () {
      super.beneficiaryId = value;
    });
  }

  late final _$expirationAtom =
      Atom(name: '_DonationStoreBase.expiration', context: context);

  @override
  String get expiration {
    _$expirationAtom.reportRead();
    return super.expiration;
  }

  @override
  set expiration(String value) {
    _$expirationAtom.reportWrite(value, super.expiration, () {
      super.expiration = value;
    });
  }

  late final _$postDonationAsyncAction =
      AsyncAction('_DonationStoreBase.postDonation', context: context);

  @override
  Future<void> postDonation({Function? onSuccess}) {
    return _$postDonationAsyncAction
        .run(() => super.postDonation(onSuccess: onSuccess));
  }

  late final _$pickImageFromCameraAsyncAction =
      AsyncAction('_DonationStoreBase.pickImageFromCamera', context: context);

  @override
  Future<void> pickImageFromCamera() {
    return _$pickImageFromCameraAsyncAction
        .run(() => super.pickImageFromCamera());
  }

  late final _$pickImageFromGalleryAsyncAction =
      AsyncAction('_DonationStoreBase.pickImageFromGallery', context: context);

  @override
  Future<void> pickImageFromGallery() {
    return _$pickImageFromGalleryAsyncAction
        .run(() => super.pickImageFromGallery());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
description: ${description},
image: ${image},
beneficiaryId: ${beneficiaryId},
expiration: ${expiration}
    ''';
  }
}
