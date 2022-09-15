// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../domain/entities/user_info.dart';
import '../../domain/usecases/user_infos/get_beneficiaries_info.dart';
import '../../domain/usecases/user_infos/get_common_users_info.dart';
import '../../domain/usecases/user_infos/get_donors_info.dart';
import '../../domain/usecases/user_infos/set_user_info_as_authorized.dart';
import '../../domain/usecases/user_infos/set_user_info_as_denied.dart';

part 'user_infos_store.g.dart';

class UserInfosStore = _UserInfosStoreBase with _$UserInfosStore;

abstract class _UserInfosStoreBase with Store {
  final GetCommonUsersInfo _getCommonUsersInfo;
  final GetBeneficiariesInfo _getBeneficiariesInfo;
  final GetDonorsInfo _getDonorsInfo;
  final SetUserInfoAsAuthorized _setUserInfoAsAuthorized;
  final SetUserInfoAsDenied _setUserInfoAsDenied;
  final List<StreamSubscription> _subscriptions = [];

  _UserInfosStoreBase(
    this._getCommonUsersInfo,
    this._getBeneficiariesInfo,
    this._getDonorsInfo,
    this._setUserInfoAsAuthorized,
    this._setUserInfoAsDenied,
  );

  @observable
  ObservableList<UserInfo> commonUsers = ObservableList.of([]);

  @observable
  ObservableList<UserInfo> beneficiaries = ObservableList.of([]);

  @observable
  ObservableList<UserInfo> donors = ObservableList.of([]);

  @action
  void init() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    _subscriptions.addAll([
      _getCommonUsersInfo().listen((list) {
        commonUsers = list.asObservable();
      }),
      _getBeneficiariesInfo().listen((list) {
        beneficiaries = list.asObservable();
      }),
      _getDonorsInfo().listen((list) {
        donors = list.asObservable();
      }),
    ]);
  }

  @action
  UserInfo getDonorById(String id) {
    return donors.firstWhere((userInfo) => userInfo.id == id);
  }

  @action
  UserInfo getBeneficiaryById(String id) {
    return beneficiaries.firstWhere((userInfo) => userInfo.id == id);
  }

  @action
  Future<void> setUserAsAuthorized(UserInfo userInfo) async {
    await _setUserInfoAsAuthorized(userInfo);
  }

  @action
  Future<void> setUserAsDenied(UserInfo userInfo) async {
    await _setUserInfoAsDenied(userInfo);
  }
}
