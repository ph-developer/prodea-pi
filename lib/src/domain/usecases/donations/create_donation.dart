import 'dart:io';

import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/donation_repo.dart';
import '../../repositories/file_repo.dart';
import '../../services/notification_service.dart';

class CreateDonation {
  final INotificationService _notificationService;
  final IAuthRepo _authRepo;
  final IDonationRepo _donationRepo;
  final IFileRepo _fileRepo;

  CreateDonation(
    this._authRepo,
    this._donationRepo,
    this._fileRepo,
    this._notificationService,
  );

  Future<Donation?> call(Donation donation, File? image) async {
    try {
      String? photoUrl;

      if (image != null) {
        photoUrl = await _fileRepo.uploadFile('donation', image);
      }

      final donorId = await _authRepo.getCurrentUserId();

      if (donorId == null) {
        _notificationService.notifyError('Usuário não autenticado.');
        return null;
      }

      var newDonation = donation.copyWith(
        donorId: donorId,
        photoUrl: photoUrl,
      );

      final createdDonation = await _donationRepo.create(newDonation);

      _notificationService.notifySuccess('Doação postada com sucesso.');

      return createdDonation;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
