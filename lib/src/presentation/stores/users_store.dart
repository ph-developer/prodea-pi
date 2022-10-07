// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../core/mixins/stream_subscriber.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/user/get_beneficiaries.dart';
import '../../domain/usecases/user/get_common_users.dart';
import '../../domain/usecases/user/get_donors.dart';
import '../../domain/usecases/user/set_user_as_authorized.dart';
import '../../domain/usecases/user/set_user_as_denied.dart';

part 'users_store.g.dart';

class UsersStore = _UsersStoreBase with _$UsersStore;

abstract class _UsersStoreBase with Store, StreamSubscriber {
  final GetCommonUsers _getCommonUsers;
  final GetBeneficiaries _getBeneficiaries;
  final GetDonors _getDonors;
  final SetUserAsAuthorized _setUserAsAuthorized;
  final SetUserAsDenied _setUserAsDenied;

  _UsersStoreBase(
    this._getCommonUsers,
    this._getBeneficiaries,
    this._getDonors,
    this._setUserAsAuthorized,
    this._setUserAsDenied,
  );

  @observable
  ObservableList<User> commonUsers = ObservableList.of([]);

  @observable
  ObservableList<User> beneficiaries = ObservableList.of([]);

  @observable
  ObservableList<User> donors = ObservableList.of([]);

  @action
  Future<void> fetchUsers() async {
    await unsubscribeAll();
    await subscribe(_getCommonUsers(), (list) {
      commonUsers = list.asObservable();
    });
    await subscribe(_getBeneficiaries(), (list) {
      beneficiaries = list.asObservable();
    });
    await subscribe(_getDonors(), (list) {
      donors = list.asObservable();
    });
  }

  @action
  User getDonorById(String id) {
    return donors.firstWhere((user) => user.id == id);
  }

  @action
  User getBeneficiaryById(String id) {
    return beneficiaries.firstWhere((user) => user.id == id);
  }

  @action
  Future<void> setUserAsAuthorized(User user) async {
    await _setUserAsAuthorized(user);
  }

  @action
  Future<void> setUserAsDenied(User user) async {
    await _setUserAsDenied(user);
  }
}
