import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart' as fake;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/data/repositories/remote/firebase_file_remote_repo.dart';

typedef FakeFirebaseStorage = fake.MockFirebaseStorage;

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

void main() {
  late File tFile;
  late FirebaseStorage storageFake;
  late FirebaseFileRemoteRepo firebaseFileRemoteRepoWithFake;
  late FirebaseStorage storageMock;
  late FirebaseFileRemoteRepo firebaseFileRemoteRepoWithMock;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    storageFake = FakeFirebaseStorage();
    firebaseFileRemoteRepoWithFake = FirebaseFileRemoteRepo(storageFake);
    storageMock = MockFirebaseStorage();
    firebaseFileRemoteRepoWithMock = FirebaseFileRemoteRepo(storageMock);

    final fileBytes = await rootBundle.load('assets/icon.png');
    tFile = File.fromRawPath(fileBytes.buffer.asUint8List());
    await storageFake.ref().child('test.png').putFile(tFile);
  });

  group('uploadFile', () {
    test(
      'deve retornar o caminho do arquivo carregado.',
      () async {
        // act
        final result =
            await firebaseFileRemoteRepoWithFake.uploadFile('test', tFile);
        // assert
        expect(result, isA<String>());
      },
    );

    test(
      'deve disparar uma UploadFileFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => storageMock.ref(any())).thenThrow(Exception());
        // act
        final result = firebaseFileRemoteRepoWithMock.uploadFile('test', tFile);
        // assert
        expect(result, throwsA(isA<UploadFileFailure>()));
      },
    );
  });

  group('getFileDownloadUrl', () {
    test(
      'deve retornar o caminho do arquivo carregado.',
      () async {
        // act
        final result =
            await firebaseFileRemoteRepoWithFake.getFileDownloadUrl('test.png');
        // assert
        expect(result, isA<String>());
      },
    );

    test(
      'deve disparar uma GetFileDownloadUrlFailure quando ocorrer algum erro.',
      () {
        // arrange
        when(() => storageMock.ref(any())).thenThrow(Exception());
        // act
        final result =
            firebaseFileRemoteRepoWithMock.getFileDownloadUrl('test.png');
        // assert
        expect(result, throwsA(isA<GetFileDownloadUrlFailure>()));
      },
    );
  });
}
