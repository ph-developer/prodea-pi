class Donation {
  final String? id;
  final String description;
  final String? photoUrl;

  final String? donorId;
  final String? beneficiaryId;

  final String expiration;
  final String? cancellation;
  final bool isDelivered;

  final DateTime? createdAt;

  Donation({
    required this.id,
    required this.description,
    required this.photoUrl,
    required this.donorId,
    required this.beneficiaryId,
    required this.expiration,
    required this.cancellation,
    required this.isDelivered,
    required this.createdAt,
  });
}
