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
    this.id,
    required this.description,
    this.photoUrl,
    this.donorId,
    this.beneficiaryId,
    required this.expiration,
    this.cancellation,
    required this.isDelivered,
    required this.createdAt,
  });
}
