import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../services/photo_service.dart';

class PickPhotoFromCamera {
  final IPhotoService _photoService;

  PickPhotoFromCamera(this._photoService);

  Future<File?> call() async {
    try {
      final photo = await _photoService.pickFromCamera();

      return photo;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
