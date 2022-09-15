// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../domain/usecases/cities/get_city_names.dart';

part 'cities_store.g.dart';

class CitiesStore = _CitiesStoreBase with _$CitiesStore;

abstract class _CitiesStoreBase with Store {
  final GetCityNames _getCityNames;
  final List<StreamSubscription> _subscriptions = [];

  _CitiesStoreBase(this._getCityNames);

  @observable
  ObservableList<String> cities = ObservableList.of([]);

  @action
  void init() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    _subscriptions.addAll([
      _getCityNames().listen((list) {
        cities = list.asObservable();
      }),
    ]);
  }
}
