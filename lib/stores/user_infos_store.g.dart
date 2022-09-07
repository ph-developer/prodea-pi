// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_infos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserInfosStore on _UserInfosStoreBase, Store {
  late final _$usersAtom =
      Atom(name: '_UserInfosStoreBase.users', context: context);

  @override
  ObservableList<UserInfo> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<UserInfo> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$beneficiariesAtom =
      Atom(name: '_UserInfosStoreBase.beneficiaries', context: context);

  @override
  ObservableList<UserInfo> get beneficiaries {
    _$beneficiariesAtom.reportRead();
    return super.beneficiaries;
  }

  @override
  set beneficiaries(ObservableList<UserInfo> value) {
    _$beneficiariesAtom.reportWrite(value, super.beneficiaries, () {
      super.beneficiaries = value;
    });
  }

  late final _$donorsAtom =
      Atom(name: '_UserInfosStoreBase.donors', context: context);

  @override
  ObservableList<UserInfo> get donors {
    _$donorsAtom.reportRead();
    return super.donors;
  }

  @override
  set donors(ObservableList<UserInfo> value) {
    _$donorsAtom.reportWrite(value, super.donors, () {
      super.donors = value;
    });
  }

  late final _$_UserInfosStoreBaseActionController =
      ActionController(name: '_UserInfosStoreBase', context: context);

  @override
  void init() {
    final _$actionInfo = _$_UserInfosStoreBaseActionController.startAction(
        name: '_UserInfosStoreBase.init');
    try {
      return super.init();
    } finally {
      _$_UserInfosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  UserInfo getDonorById(String id) {
    final _$actionInfo = _$_UserInfosStoreBaseActionController.startAction(
        name: '_UserInfosStoreBase.getDonorById');
    try {
      return super.getDonorById(id);
    } finally {
      _$_UserInfosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  UserInfo getBeneficiaryById(String id) {
    final _$actionInfo = _$_UserInfosStoreBaseActionController.startAction(
        name: '_UserInfosStoreBase.getBeneficiaryById');
    try {
      return super.getBeneficiaryById(id);
    } finally {
      _$_UserInfosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
beneficiaries: ${beneficiaries},
donors: ${donors}
    ''';
  }
}
