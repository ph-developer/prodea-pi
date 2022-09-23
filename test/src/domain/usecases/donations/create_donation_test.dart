import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/repositories/file_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/create_donation.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockDonationRepo extends Mock implements IDonationRepo {}

class MockFileRepo extends Mock implements IFileRepo {}

class MockAuthRepo extends Mock implements IAuthRepo {}

void main() {
  late File tFile;
  late INotificationService notificationServiceMock;
  late IDonationRepo donationRepoMock;
  late IFileRepo fileRepoMock;
  late IAuthRepo authRepoMock;
  late CreateDonation usecase;

  const tPhotoUrl = 'photoUrl';
  const tDonorId = 'donorId';
  final tDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    createdAt: DateTime.now(),
  );
  final tFinalDonation = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    photoUrl: tPhotoUrl,
    donorId: tDonorId,
    createdAt: DateTime.now(),
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    notificationServiceMock = MockNotificationService();
    donationRepoMock = MockDonationRepo();
    fileRepoMock = MockFileRepo();
    authRepoMock = MockAuthRepo();
    usecase = CreateDonation(
      authRepoMock,
      donationRepoMock,
      fileRepoMock,
      notificationServiceMock,
    );

    final fileBytes = await rootBundle.load('assets/icon.png');
    tFile = File.fromRawPath(fileBytes.buffer.asUint8List());
  });

  test('deve retornar a doação e notificar quando obtiver sucesso.', () async {
    // arrange
    when(() => fileRepoMock.uploadFile('donation', tFile))
        .thenAnswer((_) async => tPhotoUrl);
    when(authRepoMock.getCurrentUserId).thenAnswer((_) async => tDonorId);
    when(() => donationRepoMock.create(tFinalDonation))
        .thenAnswer((_) async => tFinalDonation);
    // act
    final result = await usecase(tDonation, tFile);
    // assert
    expect(result, isA<Donation>());
    expect(result, tFinalDonation);
    verifyNever(() => notificationServiceMock.notifyError(any()));
    verify(() => notificationServiceMock.notifySuccess(any())).called(1);
  });

  test('deve retornar null e notificar quando o usuário não estiver logado.',
      () async {
    // arrange
    when(() => fileRepoMock.uploadFile('donation', tFile))
        .thenAnswer((_) async => tPhotoUrl);
    when(authRepoMock.getCurrentUserId).thenAnswer((_) async => null);
    // act
    final result = await usecase(tDonation, tFile);
    // assert
    expect(result, null);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });

  test('deve retornar null e notificar quando ocerrer algum erro.', () async {
    // arrange
    when(() => fileRepoMock.uploadFile('donation', tFile))
        .thenAnswer((_) async => tPhotoUrl);
    when(authRepoMock.getCurrentUserId).thenAnswer((_) async => tDonorId);
    when(() => donationRepoMock.create(tFinalDonation))
        .thenThrow(CreateDonationFailure());
    // act
    final result = await usecase(tDonation, tFile);
    // assert
    expect(result, null);
    verifyNever(() => notificationServiceMock.notifySuccess(any()));
    verify(() => notificationServiceMock.notifyError(any())).called(1);
  });
}
