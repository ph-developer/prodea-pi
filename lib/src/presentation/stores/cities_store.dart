// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../core/mixins/stream_subscriber.dart';
import '../../domain/usecases/cities/get_city_names.dart';

part 'cities_store.g.dart';

class CitiesStore = _CitiesStoreBase with _$CitiesStore;

abstract class _CitiesStoreBase with Store, StreamSubscriber {
  final GetCityNames _getCityNames;

  _CitiesStoreBase(this._getCityNames);

  @observable
  ObservableList<String> cities = ObservableList.of([]);

  @action
  Future<void> fetchCities() async {
    await unsubscribeAll();
    await subscribe(_getCityNames(), (list) {
      cities = list.asObservable();
    });
  }
}
