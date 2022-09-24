import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/errors/failures.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/repositories/file_repo.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/usecases/donations/get_donation_photo_url.dart';

class MockNotificationService extends Mock implements INotificationService {}

class MockFileRepo extends Mock implements IFileRepo {}

void main() {
  late INotificationService notificationServiceMock;
  late IFileRepo fileRepoMock;
  late GetDonationPhotoUrl usecase;

  final tDonationWithPhoto = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    photoUrl: 'photoUrl',
    createdAt: DateTime.now(),
  );
  final tDonationWithoutPhoto = Donation(
    description: 'description',
    expiration: '01/01/5000',
    isDelivered: false,
    createdAt: DateTime.now(),
  );

  setUp(() {
    notificationServiceMock = MockNotificationService();
    fileRepoMock = MockFileRepo();
    usecase = GetDonationPhotoUrl(fileRepoMock, notificationServiceMock);
  });

  test(
    'deve retornar a url da imagem se a doação tiver foto.',
    () async {
      // arrange
      when(() => fileRepoMock.getFileDownloadUrl('photoUrl'))
          .thenAnswer((_) async => 'url');
      // act
      final result = await usecase(tDonationWithPhoto);
      // assert
      expect(result, 'url');
    },
  );

  test(
    'deve retornar null se a doação não tiver foto.',
    () async {
      // act
      final result = await usecase(tDonationWithoutPhoto);
      // assert
      expect(result, null);
    },
  );

  test(
    'deve retornar null e notificar quando algum erro ocorrer.',
    () async {
      // arrange
      when(() => fileRepoMock.getFileDownloadUrl('photoUrl'))
          .thenThrow(GetFileDownloadUrlFailure());
      // act
      final result = await usecase(tDonationWithPhoto);
      // assert
      expect(result, null);
      verify(() => notificationServiceMock.notifyError(any())).called(1);
    },
  );
}
