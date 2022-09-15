// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_infos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserInfosStore on _UserInfosStoreBase, Store {
  late final _$commonUsersAtom =
      Atom(name: '_UserInfosStoreBase.commonUsers', context: context);

  @override
  ObservableList<UserInfo> get commonUsers {
    _$commonUsersAtom.reportRead();
    return super.commonUsers;
  }

  @override
  set commonUsers(ObservableList<UserInfo> value) {
    _$commonUsersAtom.reportWrite(value, super.commonUsers, () {
      super.commonUsers = value;
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

  late final _$setUserAsAuthorizedAsyncAction =
      AsyncAction('_UserInfosStoreBase.setUserAsAuthorized', context: context);

  @override
  Future<void> setUserAsAuthorized(UserInfo userInfo) {
    return _$setUserAsAuthorizedAsyncAction
        .run(() => super.setUserAsAuthorized(userInfo));
  }

  late final _$setUserAsDeniedAsyncAction =
      AsyncAction('_UserInfosStoreBase.setUserAsDenied', context: context);

  @override
  Future<void> setUserAsDenied(UserInfo userInfo) {
    return _$setUserAsDeniedAsyncAction
        .run(() => super.setUserAsDenied(userInfo));
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
commonUsers: ${commonUsers},
beneficiaries: ${beneficiaries},
donors: ${donors}
    ''';
  }
}
