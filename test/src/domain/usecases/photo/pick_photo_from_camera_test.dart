import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/services/photo_service.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_camera.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockPhotoService extends Mock implements IPhotoService {}

void main() {
  late File tFile;
  late INotificationService notificationServiceMock;
  late IPhotoService photoServiceMock;
  late PickPhotoFromCamera usecase;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    notificationServiceMock = MockNotificationService();
    photoServiceMock = MockPhotoService();
    usecase = PickPhotoFromCamera(photoServiceMock, notificationServiceMock);

    final fileBytes = await rootBundle.load('assets/icon.png');
    tFile = File.fromRawPath(fileBytes.buffer.asUint8List());
  });

  test(
    'deve retornar um File quando uma foto for selecionada.',
    () async {
      // arrange
      when(photoServiceMock.pickFromCamera).thenAnswer((_) async => tFile);
      // act
      final result = await usecase();
      // assert
      expect(result, tFile);
    },
  );

  test(
    'deve retornar null quando nenhuma foto for selecionada.',
    () async {
      // arrange
      when(photoServiceMock.pickFromCamera).thenAnswer((_) async => null);
      // act
      final result = await usecase();
      // assert
      expect(result, null);
    },
  );

  test(
    'deve retornar null e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(photoServiceMock.pickFromCamera).thenThrow(PhotoPickFailure());
      // act
      final result = await usecase();
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
