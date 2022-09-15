import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../services/photo_service.dart';

class PickPhotoFromGallery {
  final IPhotoService _photoService;

  PickPhotoFromGallery(this._photoService);

  Future<File?> call() async {
    try {
      final photo = await _photoService.pickFromGallery();

      return photo;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
