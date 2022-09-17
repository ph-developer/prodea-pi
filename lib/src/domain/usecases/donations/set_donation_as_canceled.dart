import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/donation_repo.dart';
import '../../services/notification_service.dart';

class SetDonationAsCanceled {
  final INotificationService _notificationService;
  final IDonationRepo _donationRepo;

  SetDonationAsCanceled(this._donationRepo, this._notificationService);

  Future<Donation?> call(Donation donation, String reason) async {
    try {
      final newDonation = donation.copyWith(
        cancellation: reason,
      );

      final updatedDonation = await _donationRepo.update(newDonation);

      return updatedDonation;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
