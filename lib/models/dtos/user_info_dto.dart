import 'package:prodea/models/user_info.dart';

extension UserInfoDTO on UserInfo {
  UserInfo copyWith({
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
    return UserInfo(
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'cnpj': cnpj,
      'name': name,
      'address': address,
      'city': city,
      'phoneNumber': phoneNumber,
      'about': about,
      'responsibleName': responsibleName,
      'responsibleCpf': responsibleCpf,
      'isDonor': isDonor,
      'isBeneficiary': isBeneficiary,
      'isAdmin': isAdmin,
      'status': status,
    };
  }

  static UserInfo fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      email: map['email'],
      cnpj: map['cnpj'],
      name: map['name'],
      address: map['address'],
      city: map['city'],
      phoneNumber: map['phoneNumber'],
      about: map['about'],
      responsibleName: map['responsibleName'],
      responsibleCpf: map['responsibleCpf'],
      isDonor: map['isDonor'],
      isBeneficiary: map['isBeneficiary'],
      isAdmin: map['isAdmin'],
      status: map['status'],
    );
  }
}
