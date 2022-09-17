// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:mobx/mobx.dart';

import '../../../core/helpers/navigation.dart';
import '../../domain/entities/donation.dart';
import '../../domain/usecases/donations/create_donation.dart';
import '../../domain/usecases/photo/pick_photo_from_camera.dart';
import '../../domain/usecases/photo/pick_photo_from_gallery.dart';

part 'donation_store.g.dart';

class DonationStore = _DonationStoreBase with _$DonationStore;

abstract class _DonationStoreBase with Store {
  final CreateDonation _createDonation;
  final PickPhotoFromCamera _pickPhotoFromCamera;
  final PickPhotoFromGallery _pickPhotoFromGallery;

  _DonationStoreBase(
    this._createDonation,
    this._pickPhotoFromCamera,
    this._pickPhotoFromGallery,
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

    final donation = Donation(
      description: description,
      beneficiaryId: beneficiaryId,
      expiration: expiration,
      isDelivered: false,
      createdAt: DateTime.now(),
    );

    final createdDonation = await _createDonation(donation, image);

    if (createdDonation != null) {
      NavigationHelper.goTo('/main/my-donations', replace: true);
    }

    isLoading = false;
  }

  @action
  Future<void> pickImageFromCamera() async {
    final photo = await _pickPhotoFromCamera();
    if (photo != null) image = photo;
  }

  @action
  Future<void> pickImageFromGallery() async {
    final photo = await _pickPhotoFromGallery();
    if (photo != null) image = photo;
  }
}
