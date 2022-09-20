// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/entities/user.dart';

part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store {
  @observable
  String email = '';

  @observable
  String cnpj = '';

  @observable
  String name = '';

  @observable
  String address = '';

  @observable
  String city = '';

  @observable
  String phoneNumber = '';

  @observable
  String about = '';

  @observable
  String responsibleName = '';

  @observable
  String responsibleCpf = '';

  @observable
  bool isDonor = false;

  @observable
  bool isBeneficiary = false;

  @computed
  User get user => User(
        id: null,
        email: email,
        cnpj: cnpj,
        name: name,
        address: address,
        city: city,
        phoneNumber: phoneNumber,
        about: about,
        responsibleName: responsibleName,
        responsibleCpf: responsibleCpf,
        isDonor: isDonor,
        isBeneficiary: isBeneficiary,
        isAdmin: false,
        status: AuthorizationStatus.waiting,
      );
}
