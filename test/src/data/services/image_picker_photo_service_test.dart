import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/services/image_picker_photo_service.dart';

import '../../../mocks/mocks.dart';

void main() {
  late XFile tXFile;
  late ImagePicker imagePickerMock;
  late ImagePickerPhotoService imagePickerPhotoService;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    imagePickerMock = MockImagePicker();
    imagePickerPhotoService = ImagePickerPhotoService(imagePickerMock);

    final data = await rootBundle.load('assets/icon.png');
    final bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
    tXFile = XFile.fromData(file.readAsBytesSync());
  });

  group('pickFromCamera', () {
    test(
      'deve retornar um arquivo quando uma imagem for selecionada.',
      () async {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => tXFile);
        // act
        final result = await imagePickerPhotoService.pickFromCamera();
        // assert
        expect(result, isA<File>());
      },
    );

    test(
      'deve retornar null quando uma imagem não for selecionada.',
      () async {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => null);
        // act
        final result = await imagePickerPhotoService.pickFromCamera();
        // assert
        expect(result, isNull);
      },
    );

    test(
      'deve disparar uma PhotoPickFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.camera))
            .thenThrow(Exception());
        // act
        final result = imagePickerPhotoService.pickFromCamera();
        // assert
        expect(result, throwsA(isA<PhotoPickFailure>()));
      },
    );
  });

  group('pickFromGallery', () {
    test(
      'deve retornar um arquivo quando uma imagem for selecionada.',
      () async {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => tXFile);
        // act
        final result = await imagePickerPhotoService.pickFromGallery();
        // assert
        expect(result, isA<File>());
      },
    );

    test(
      'deve retornar null quando uma imagem não for selecionada.',
      () async {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => null);
        // act
        final result = await imagePickerPhotoService.pickFromGallery();
        // assert
        expect(result, isNull);
      },
    );

    test(
      'deve disparar uma PhotoPickFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => imagePickerMock.pickImage(source: ImageSource.gallery))
            .thenThrow(Exception());
        // act
        final result = imagePickerPhotoService.pickFromGallery();
        // assert
        expect(result, throwsA(isA<PhotoPickFailure>()));
      },
    );
  });
}
