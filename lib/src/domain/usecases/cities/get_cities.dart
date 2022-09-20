import '../../entities/city.dart';
import '../../repositories/city_repo.dart';

class GetCities {
  final ICityRepo _cityRepo;

  GetCities(this._cityRepo);

  Stream<List<City>> call() {
    return _cityRepo.getCities().map(_orderList);
  }

  List<City> _orderList(List<City> list) {
    return list..sort((a, b) => a.name.compareTo(b.name));
  }
}
