import 'dart:io';

abstract class IPhotoService {
  Future<File?> pickFromCamera();
  Future<File?> pickFromGallery();
}
