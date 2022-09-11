// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:prodea/models/dtos/city_dto.dart';
import 'package:prodea/repositories/contracts/city_repo.dart';

part 'cities_store.g.dart';

class CitiesStore = _CitiesStoreBase with _$CitiesStore;

abstract class _CitiesStoreBase with Store {
  final ICityRepo cityRepo;

  _CitiesStoreBase(
    this.cityRepo,
  );

  @observable
  ObservableList<String> cities = ObservableList.of([]);

  @action
  Future<void> init() async {
    final tmp = await cityRepo.getCities();
    final list = tmp.map((city) => city.value).toList();
    list.sort((a, b) => a.toString().compareTo(b.toString()));

    cities = list.asObservable();
  }
}
