import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/donation.dart';

extension DonationDTO on Donation {
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'photoUrl': photoUrl,
      'donorId': donorId,
      'beneficiaryId': beneficiaryId,
      'expiration': expiration,
      'cancellation': cancellation,
      'isDelivered': isDelivered,
      'createdAt': createdAt,
    };
  }

  static Donation fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      description: map['description'],
      photoUrl: map['photoUrl'],
      donorId: map['donorId'],
      beneficiaryId: map['beneficiaryId'],
      expiration: map['expiration'],
      cancellation: map['cancellation'],
      isDelivered: map['isDelivered'],
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
