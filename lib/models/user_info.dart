class UserInfo {
  final String? id;
  final String email;

  final String cnpj;
  final String name;
  final String address;
  final String city;
  final String phoneNumber;
  final String about;
  final String responsibleName;
  final String responsibleCpf;

  final bool isDonor;
  final bool isBeneficiary;
  final bool isAdmin;

  final AuthorizationStatus status;

  UserInfo({
    required this.id,
    required this.email,
    required this.cnpj,
    required this.name,
    required this.address,
    required this.city,
    required this.phoneNumber,
    required this.about,
    required this.responsibleName,
    required this.responsibleCpf,
    required this.isDonor,
    required this.isBeneficiary,
    required this.isAdmin,
    required this.status,
  });
}

enum AuthorizationStatus {
  waiting(0),
  authorized(1),
  denied(2);

  final int statusCode;

  const AuthorizationStatus(this.statusCode);
}
