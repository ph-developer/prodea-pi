// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';

part 'user_infos_store.g.dart';

class UserInfosStore = _UserInfosStoreBase with _$UserInfosStore;

abstract class _UserInfosStoreBase with Store {
  final IUserInfoRepo userInfoRepo;
  final List<StreamSubscription> _subscriptions = [];

  _UserInfosStoreBase(this.userInfoRepo);

  @observable
  ObservableList<UserInfo> users = ObservableList.of([]);

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

    final subUsers = userInfoRepo.usersInfo().listen((infos) {
      users = infos.asObservable();
    });
    _subscriptions.add(subUsers);

    final subBeneficiaries = userInfoRepo.beneficiariesInfo().listen((infos) {
      beneficiaries = infos.asObservable();
    });
    _subscriptions.add(subBeneficiaries);

    final subDonors = userInfoRepo.donorsInfo().listen((infos) {
      donors = infos.asObservable();
    });
    _subscriptions.add(subDonors);
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
    await userInfoRepo.setStatus(userInfo, AuthorizationStatus.authorized);
  }

  @action
  Future<void> setUserAsDenied(UserInfo userInfo) async {
    await userInfoRepo.setStatus(userInfo, AuthorizationStatus.denied);
  }
}
