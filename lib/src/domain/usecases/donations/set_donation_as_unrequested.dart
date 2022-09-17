import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/donation_repo.dart';
import '../../services/notification_service.dart';

class SetDonationAsUnrequested {
  final INotificationService _notificationService;
  final IDonationRepo _donationRepo;

  SetDonationAsUnrequested(this._donationRepo, this._notificationService);

  Future<Donation?> call(Donation donation) async {
    try {
      final newDonation = donation.copyWith(
        beneficiaryId: 'null',
      );

      final updatedDonation = await _donationRepo.update(newDonation);

      return updatedDonation;
    } on Failure catch (failure) {
      _notificationService.notifyError(failure.message);
      return null;
    }
  }
}
