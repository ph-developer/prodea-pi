import '../../dtos/city_dto.dart';
import '../../entities/city.dart';
import '../../repositories/city_repo.dart';

class GetCityNames {
  final ICityRepo _cityRepo;

  GetCityNames(this._cityRepo);

  Stream<List<String>> call() {
    return _cityRepo.getCities().map(_convertList).map(_orderList);
  }

  List<String> _convertList(List<City> list) {
    return list.map((city) => city.value).toList();
  }

  List<String> _orderList(List<String> list) {
    return list..sort((a, b) => a.compareTo(b));
  }
}
