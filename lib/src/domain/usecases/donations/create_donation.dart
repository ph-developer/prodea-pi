import 'dart:io';

import '../../../../core/helpers/notification.dart';
import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/donation_repo.dart';
import '../../repositories/file_repo.dart';

class CreateDonation {
  final IAuthRepo _authRepo;
  final IDonationRepo _donationRepo;
  final IFileRepo _fileRepo;

  CreateDonation(this._authRepo, this._donationRepo, this._fileRepo);

  Future<Donation?> call(Donation donation, File? image) async {
    try {
      String? photoUrl;

      if (image != null) {
        photoUrl = await _fileRepo.uploadFile('donation', image);
      }

      final user = await _authRepo.getCurrentUser().first;

      if (user == null) {
        NotificationHelper.notifyError('Usuário não autenticado.');
        return null;
      }

      final donorId = user.id;

      var newDonation = donation.copyWith(
        donorId: donorId,
        photoUrl: photoUrl,
      );

      final createdDonation = await _donationRepo.create(newDonation);

      return createdDonation;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
