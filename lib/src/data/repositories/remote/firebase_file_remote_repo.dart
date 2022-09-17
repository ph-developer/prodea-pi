import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/file_repo.dart';

class FirebaseFileRemoteRepo implements IFileRepo {
  final FirebaseStorage _storage;

  FirebaseFileRemoteRepo(this._storage);

  @override
  Future<String> uploadFile(String path, File file) async {
    try {
      final fileName = const Uuid().v4();
      final fileRef = _storage.ref("$path/$fileName");
      final task = await fileRef.putFile(file);

      return task.ref.fullPath;
    } catch (e) {
      throw UploadFileFailure();
    }
  }

  @override
  Future<String> getFileDownloadUrl(String path) async {
    try {
      final fileRef = _storage.ref(path);
      final downloadUrl = await fileRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw GetFileDownloadUrlFailure();
    }
  }
}
