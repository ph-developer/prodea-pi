import '../../../../core/errors/failures.dart';
import '../../entities/donation.dart';
import '../../repositories/file_repo.dart';
import '../../services/notification_service.dart';

class GetDonationPhotoUrl {
  final INotificationService _notificationService;
  final IFileRepo _fileRepo;

  GetDonationPhotoUrl(this._fileRepo, this._notificationService);

  Future<String?> call(Donation donation) async {
    try {
      final photoPath = donation.photoUrl;

      if (photoPath == null) {
        return null;
      }

      final fileUrl = await _fileRepo.getFileDownloadUrl(photoPath);

      return fileUrl;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
