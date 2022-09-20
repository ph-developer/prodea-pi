import '../../domain/entities/user.dart';

extension UserDTO on User {
  Map<String, dynamic> toMap() {
    return {
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
      'status': status.statusCode,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
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
      status: AuthorizationStatus.values.firstWhere(
        (status) => status.statusCode == map['status'],
      ),
    );
  }
}
