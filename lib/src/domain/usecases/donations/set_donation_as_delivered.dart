import '../../../../core/helpers/notification.dart';
import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/donation_repo.dart';

class SetDonationAsDelivered {
  final IDonationRepo _donationRepo;

  SetDonationAsDelivered(this._donationRepo);

  Future<Donation?> call(Donation donation) async {
    try {
      final newDonation = donation.copyWith(
        isDelivered: true,
      );

      final updatedDonation = await _donationRepo.update(newDonation);

      return updatedDonation;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
