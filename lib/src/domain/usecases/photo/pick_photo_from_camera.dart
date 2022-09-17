import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../../services/notification_service.dart';
import '../../services/photo_service.dart';

class PickPhotoFromCamera {
  final INotificationService _notificationService;
  final IPhotoService _photoService;

  PickPhotoFromCamera(this._photoService, this._notificationService);

  Future<File?> call() async {
    try {
      final photo = await _photoService.pickFromCamera();

      return photo;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
