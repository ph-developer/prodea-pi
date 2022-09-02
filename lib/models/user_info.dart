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

  UserInfo(
    this.id,
    this.email,
    this.cnpj,
    this.name,
    this.address,
    this.city,
    this.phoneNumber,
    this.about,
    this.responsibleName,
    this.responsibleCpf,
    this.isDonor,
    this.isBeneficiary,
    this.isAdmin,
    this.status,
  );
}

enum AuthorizationStatus {
  waiting(0),
  authorized(1),
  denied(2);

  final int statusCode;

  const AuthorizationStatus(this.statusCode);
}
