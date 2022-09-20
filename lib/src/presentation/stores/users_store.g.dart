// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsersStore on _UsersStoreBase, Store {
  late final _$commonUsersAtom =
      Atom(name: '_UsersStoreBase.commonUsers', context: context);

  @override
  ObservableList<User> get commonUsers {
    _$commonUsersAtom.reportRead();
    return super.commonUsers;
  }

  @override
  set commonUsers(ObservableList<User> value) {
    _$commonUsersAtom.reportWrite(value, super.commonUsers, () {
      super.commonUsers = value;
    });
  }

  late final _$beneficiariesAtom =
      Atom(name: '_UsersStoreBase.beneficiaries', context: context);

  @override
  ObservableList<User> get beneficiaries {
    _$beneficiariesAtom.reportRead();
    return super.beneficiaries;
  }

  @override
  set beneficiaries(ObservableList<User> value) {
    _$beneficiariesAtom.reportWrite(value, super.beneficiaries, () {
      super.beneficiaries = value;
    });
  }

  late final _$donorsAtom =
      Atom(name: '_UsersStoreBase.donors', context: context);

  @override
  ObservableList<User> get donors {
    _$donorsAtom.reportRead();
    return super.donors;
  }

  @override
  set donors(ObservableList<User> value) {
    _$donorsAtom.reportWrite(value, super.donors, () {
      super.donors = value;
    });
  }

  late final _$setUserAsAuthorizedAsyncAction =
      AsyncAction('_UsersStoreBase.setUserAsAuthorized', context: context);

  @override
  Future<void> setUserAsAuthorized(User user) {
    return _$setUserAsAuthorizedAsyncAction
        .run(() => super.setUserAsAuthorized(user));
  }

  late final _$setUserAsDeniedAsyncAction =
      AsyncAction('_UsersStoreBase.setUserAsDenied', context: context);

  @override
  Future<void> setUserAsDenied(User user) {
    return _$setUserAsDeniedAsyncAction.run(() => super.setUserAsDenied(user));
  }

  late final _$_UsersStoreBaseActionController =
      ActionController(name: '_UsersStoreBase', context: context);

  @override
  void init() {
    final _$actionInfo = _$_UsersStoreBaseActionController.startAction(
        name: '_UsersStoreBase.init');
    try {
      return super.init();
    } finally {
      _$_UsersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  User getDonorById(String id) {
    final _$actionInfo = _$_UsersStoreBaseActionController.startAction(
        name: '_UsersStoreBase.getDonorById');
    try {
      return super.getDonorById(id);
    } finally {
      _$_UsersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  User getBeneficiaryById(String id) {
    final _$actionInfo = _$_UsersStoreBaseActionController.startAction(
        name: '_UsersStoreBase.getBeneficiaryById');
    try {
      return super.getBeneficiaryById(id);
    } finally {
      _$_UsersStoreBaseActionController.endAction(_$actionInfo);
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
