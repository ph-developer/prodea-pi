import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/donation.dart';
import '../../dtos/donation_dto.dart';
import '../../dtos/firebase_dto.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/donation_repo.dart';

class FirebaseDonationRemoteRepo implements IDonationRepo {
  final FirebaseFirestore _firestore;

  FirebaseDonationRemoteRepo(this._firestore);

  CollectionReference get _collectionRef => _firestore.collection('donation');

  @override
  Future<Donation> create(Donation donation) async {
    try {
      final donationMap = donation.toMap();
      final docRef = await _collectionRef.add(donationMap);
      donationMap['id'] = docRef.id;
      final createdDonation = DonationDTO.fromMap(donationMap);

      return createdDonation;
    } catch (e) {
      throw CreateDonationFailure();
    }
  }

  @override
  Future<Donation> update(Donation donation) async {
    try {
      final docRef = _collectionRef.doc(donation.id);
      await docRef.set(donation.toMap());

      return donation;
    } catch (e) {
      throw UpdateDonationFailure();
    }
  }

  @override
  Stream<List<Donation>> getDonations() {
    return _collectionRef.snapshots().map((snapshot) => snapshot.docs).map(
        (list) => list
            .map((donation) => donation.toMap())
            .map(DonationDTO.fromMap)
            .toList());
  }
}
