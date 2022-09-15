// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserInfoStore on _UserInfoStoreBase, Store {
  Computed<UserInfo>? _$userInfoComputed;

  @override
  UserInfo get userInfo =>
      (_$userInfoComputed ??= Computed<UserInfo>(() => super.userInfo,
              name: '_UserInfoStoreBase.userInfo'))
          .value;

  late final _$emailAtom =
      Atom(name: '_UserInfoStoreBase.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$cnpjAtom =
      Atom(name: '_UserInfoStoreBase.cnpj', context: context);

  @override
  String get cnpj {
    _$cnpjAtom.reportRead();
    return super.cnpj;
  }

  @override
  set cnpj(String value) {
    _$cnpjAtom.reportWrite(value, super.cnpj, () {
      super.cnpj = value;
    });
  }

  late final _$nameAtom =
      Atom(name: '_UserInfoStoreBase.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$addressAtom =
      Atom(name: '_UserInfoStoreBase.address', context: context);

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$cityAtom =
      Atom(name: '_UserInfoStoreBase.city', context: context);

  @override
  String get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(String value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  late final _$phoneNumberAtom =
      Atom(name: '_UserInfoStoreBase.phoneNumber', context: context);

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  late final _$aboutAtom =
      Atom(name: '_UserInfoStoreBase.about', context: context);

  @override
  String get about {
    _$aboutAtom.reportRead();
    return super.about;
  }

  @override
  set about(String value) {
    _$aboutAtom.reportWrite(value, super.about, () {
      super.about = value;
    });
  }

  late final _$responsibleNameAtom =
      Atom(name: '_UserInfoStoreBase.responsibleName', context: context);

  @override
  String get responsibleName {
    _$responsibleNameAtom.reportRead();
    return super.responsibleName;
  }

  @override
  set responsibleName(String value) {
    _$responsibleNameAtom.reportWrite(value, super.responsibleName, () {
      super.responsibleName = value;
    });
  }

  late final _$responsibleCpfAtom =
      Atom(name: '_UserInfoStoreBase.responsibleCpf', context: context);

  @override
  String get responsibleCpf {
    _$responsibleCpfAtom.reportRead();
    return super.responsibleCpf;
  }

  @override
  set responsibleCpf(String value) {
    _$responsibleCpfAtom.reportWrite(value, super.responsibleCpf, () {
      super.responsibleCpf = value;
    });
  }

  late final _$isDonorAtom =
      Atom(name: '_UserInfoStoreBase.isDonor', context: context);

  @override
  bool get isDonor {
    _$isDonorAtom.reportRead();
    return super.isDonor;
  }

  @override
  set isDonor(bool value) {
    _$isDonorAtom.reportWrite(value, super.isDonor, () {
      super.isDonor = value;
    });
  }

  late final _$isBeneficiaryAtom =
      Atom(name: '_UserInfoStoreBase.isBeneficiary', context: context);

  @override
  bool get isBeneficiary {
    _$isBeneficiaryAtom.reportRead();
    return super.isBeneficiary;
  }

  @override
  set isBeneficiary(bool value) {
    _$isBeneficiaryAtom.reportWrite(value, super.isBeneficiary, () {
      super.isBeneficiary = value;
    });
  }

  @override
  String toString() {
    return '''
email: ${email},
cnpj: ${cnpj},
name: ${name},
address: ${address},
city: ${city},
phoneNumber: ${phoneNumber},
about: ${about},
responsibleName: ${responsibleName},
responsibleCpf: ${responsibleCpf},
isDonor: ${isDonor},
isBeneficiary: ${isBeneficiary},
userInfo: ${userInfo}
    ''';
  }
}
