import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/usecases/donations/create_donation.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_camera.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_gallery.dart';
import 'package:prodea/src/presentation/stores/donation_store.dart';

class MockModularNavigator extends Mock implements IModularNavigator {}

class MockCreateDonation extends Mock implements CreateDonation {}

class MockPickPhotoFromCamera extends Mock implements PickPhotoFromCamera {}

class MockPickPhotoFromGallery extends Mock implements PickPhotoFromGallery {}

void main() {
  late File tFile;
  late IModularNavigator modularNavigatorMock;
  late CreateDonation createDonationMock;
  late PickPhotoFromCamera pickPhotoFromCameraMock;
  late PickPhotoFromGallery pickPhotoFromGalleryMock;
  late DonationStore store;

  final tDonation = Donation(
    description: 'description',
    beneficiaryId: 'beneficiaryId',
    expiration: '01/01/2022',
    isDelivered: false,
    createdAt: DateTime.now(),
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    modularNavigatorMock = MockModularNavigator();
    createDonationMock = MockCreateDonation();
    pickPhotoFromCameraMock = MockPickPhotoFromCamera();
    pickPhotoFromGalleryMock = MockPickPhotoFromGallery();
    store = DonationStore(
        createDonationMock, pickPhotoFromCameraMock, pickPhotoFromGalleryMock);

    final fileBytes = await rootBundle.load('assets/icon.png');
    tFile = File.fromRawPath(fileBytes.buffer.asUint8List());
    Modular.navigatorDelegate = modularNavigatorMock;

    registerFallbackValue(tDonation);
  });

  group('postDonation', () {
    test(
      'deve navegar para a página "minhas doações" quando postar uma doação com sucesso.',
      () async {
        // arrange
        store.description = tDonation.description;
        store.beneficiaryId = tDonation.beneficiaryId;
        store.expiration = tDonation.expiration;
        when(() => createDonationMock(tDonation, null))
            .thenAnswer((_) async => tDonation);
        // act
        await store.postDonation();
        // assert
        expect(store.isLoading, false);
        verify(() => createDonationMock(tDonation, null)).called(1);
        verify(() => modularNavigatorMock.navigate(any())).called(1);
      },
    );

    test(
      'deve manter-se na página quando não conseguir postar a doação.',
      () async {
        // arrange
        store.description = tDonation.description;
        store.beneficiaryId = tDonation.beneficiaryId;
        store.expiration = tDonation.expiration;
        when(() => createDonationMock(tDonation, null))
            .thenAnswer((_) async => null);
        // act
        await store.postDonation();
        // assert
        expect(store.isLoading, false);
        verify(() => createDonationMock(tDonation, null)).called(1);
        verifyNever(() => modularNavigatorMock.navigate(any()));
      },
    );
  });

  group('pickImageFromCamera', () {
    test(
      'deve alterar a imagem quando for selecionada uma foto da câmera.',
      () async {
        // arrange
        when(pickPhotoFromCameraMock).thenAnswer((_) async => tFile);
        // act
        await store.pickImageFromCamera();
        // assert
        expect(store.image, tFile);
      },
    );

    test(
      'deve manter a imagem quando não for selecionada uma foto da câmera.',
      () async {
        // arrange
        store.image = tFile;
        when(pickPhotoFromCameraMock).thenAnswer((_) async => null);
        // act
        await store.pickImageFromCamera();
        // assert
        expect(store.image, tFile);
      },
    );
  });

  group('pickImageFromGallery', () {
    test(
      'deve alterar a imagem quando for selecionada uma foto da galeria.',
      () async {
        // arrange
        when(pickPhotoFromGalleryMock).thenAnswer((_) async => tFile);
        // act
        await store.pickImageFromGallery();
        // assert
        expect(store.image, tFile);
      },
    );

    test(
      'deve manter a imagem quando não for selecionada uma foto da galeria.',
      () async {
        // arrange
        store.image = tFile;
        when(pickPhotoFromGalleryMock).thenAnswer((_) async => null);
        // act
        await store.pickImageFromGallery();
        // assert
        expect(store.image, tFile);
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = store.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
