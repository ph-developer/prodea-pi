import '../../../../core/helpers/notification.dart';
import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/donation_repo.dart';

class SetDonationAsCanceled {
  final IDonationRepo _donationRepo;

  SetDonationAsCanceled(this._donationRepo);

  Future<Donation?> call(Donation donation, String reason) async {
    try {
      final newDonation = donation.copyWith(
        cancellation: reason,
      );

      final updatedDonation = await _donationRepo.update(newDonation);

      return updatedDonation;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
