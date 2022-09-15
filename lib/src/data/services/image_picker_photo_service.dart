import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/errors/failures.dart';
import '../../domain/services/photo_service.dart';

class ImagePickerPhotoService implements IPhotoService {
  final ImagePicker _imagePicker;

  ImagePickerPhotoService(this._imagePicker);

  @override
  Future<File?> pickFromCamera() async {
    return _pickFromSource(ImageSource.camera);
  }

  @override
  Future<File?> pickFromGallery() async {
    return _pickFromSource(ImageSource.gallery);
  }

  Future<File?> _pickFromSource(ImageSource source) async {
    try {
      final fileInfo = await _imagePicker.pickImage(source: source);
      if (fileInfo == null) return null;
      final file = File(fileInfo.path);
      return file;
    } catch (e) {
      throw PhotoPickFailure();
    }
  }
}
