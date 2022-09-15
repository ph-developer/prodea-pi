import 'dart:io';

abstract class IFileRepo {
  Future<String> uploadFile(String path, File file);
  Future<String> getFileDownloadUrl(String path);
}
