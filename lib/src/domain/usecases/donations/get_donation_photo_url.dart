import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/notification.dart';
import '../../entities/donation.dart';
import '../../repositories/file_repo.dart';

class GetDonationPhotoUrl {
  final IFileRepo _fileRepo;

  GetDonationPhotoUrl(this._fileRepo);

  Future<String?> call(Donation donation) async {
    try {
      final photoPath = donation.photoUrl;

      if (photoPath == null) {
        return null;
      }

      final fileUrl = await _fileRepo.getFileDownloadUrl(photoPath);

      return fileUrl;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
