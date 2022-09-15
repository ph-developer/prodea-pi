import '../../../../core/helpers/notification.dart';
import '../../dtos/donation_dto.dart';
import '../../entities/donation.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/donation_repo.dart';

class SetDonationAsRequested {
  final IAuthRepo _authRepo;
  final IDonationRepo _donationRepo;

  SetDonationAsRequested(this._authRepo, this._donationRepo);

  Future<Donation?> call(Donation donation) async {
    try {
      final user = await _authRepo.getCurrentUser().first;

      if (user == null) {
        NotificationHelper.notifyError('Usuário não autenticado.');
        return null;
      }

      final beneficiaryId = user.id;

      final newDonation = donation.copyWith(
        beneficiaryId: beneficiaryId,
      );

      final updatedDonation = await _donationRepo.update(newDonation);

      return updatedDonation;
    } on Failure catch (failure) {
      NotificationHelper.notifyError(failure.message);
      return null;
    }
  }
}
