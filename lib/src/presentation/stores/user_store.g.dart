// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStoreBase, Store {
  Computed<User>? _$userComputed;

  @override
  User get user => (_$userComputed ??=
          Computed<User>(() => super.user, name: '_UserStoreBase.user'))
      .value;

  late final _$emailAtom = Atom(name: '_UserStoreBase.email', context: context);

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

  late final _$cnpjAtom = Atom(name: '_UserStoreBase.cnpj', context: context);

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

  late final _$nameAtom = Atom(name: '_UserStoreBase.name', context: context);

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
      Atom(name: '_UserStoreBase.address', context: context);

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

  late final _$cityAtom = Atom(name: '_UserStoreBase.city', context: context);

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
      Atom(name: '_UserStoreBase.phoneNumber', context: context);

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

  late final _$aboutAtom = Atom(name: '_UserStoreBase.about', context: context);

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
      Atom(name: '_UserStoreBase.responsibleName', context: context);

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
      Atom(name: '_UserStoreBase.responsibleCpf', context: context);

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
      Atom(name: '_UserStoreBase.isDonor', context: context);

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
      Atom(name: '_UserStoreBase.isBeneficiary', context: context);

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
user: ${user}
    ''';
  }
}
