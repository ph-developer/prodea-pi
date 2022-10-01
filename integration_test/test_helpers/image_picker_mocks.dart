import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<ImagePicker> setupImagePickerMock() async {
  const channel = MethodChannel('plugins.flutter.io/image_picker_android');

  Future<String> handler(MethodCall methodCall) async {
    final data = await rootBundle.load('assets/icon.png');
    final bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
    return file.path;
  }

  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, handler);

  return ImagePicker();
}
