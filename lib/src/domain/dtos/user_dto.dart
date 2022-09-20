import '../entities/user.dart';

extension UserDTO on User {
  User copyWith({
    String? id,
    String? email,
    String? cnpj,
    String? name,
    String? address,
    String? city,
    String? phoneNumber,
    String? about,
    String? responsibleName,
    String? responsibleCpf,
    bool? isDonor,
    bool? isBeneficiary,
    bool? isAdmin,
    AuthorizationStatus? status,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      cnpj: cnpj ?? this.cnpj,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      responsibleName: responsibleName ?? this.responsibleName,
      responsibleCpf: responsibleCpf ?? this.responsibleCpf,
      isDonor: isDonor ?? this.isDonor,
      isBeneficiary: isBeneficiary ?? this.isBeneficiary,
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
    );
  }
}
