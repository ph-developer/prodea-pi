import '../entities/city.dart';

abstract class ICityRepo {
  Stream<List<City>> getCities();
}
