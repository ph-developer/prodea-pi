import 'package:intl/intl.dart';

import '../entities/donation.dart';

extension DonationDTO on Donation {
  Donation copyWith({
    String? id,
    String? description,
    String? photoUrl,
    String? donorId,
    String? beneficiaryId,
    String? expiration,
    String? cancellation,
    bool? isDelivered,
    DateTime? createdAt,
  }) {
    return Donation(
      id: id ?? this.id,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      donorId: donorId ?? this.donorId,
      beneficiaryId: beneficiaryId == 'null'
          ? null
          : (beneficiaryId ?? this.beneficiaryId),
      expiration: expiration ?? this.expiration,
      cancellation: cancellation ?? this.cancellation,
      isDelivered: isDelivered ?? this.isDelivered,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isExpired {
    final expiration =
        DateFormat('d/M/y H:m').parse("${this.expiration} 23:59");
    final diff = expiration.difference(DateTime.now()).inMinutes;

    return diff < 0;
  }

  String get status {
    if (cancellation != null) {
      return "Cancelada. Motivo: $cancellation";
    } else if (isDelivered) {
      return "Doação retirada ou entregue";
    } else if (isExpired) {
      return "Validade expirada";
    } else if (beneficiaryId == null) {
      return "Aguardando interessados";
    } else {
      return "Aguardando retirada ou entrega";
    }
  }
}
