import 'package:prodea/models/city.dart';

abstract class ICityRepo {
  Future<List<City>> getCities();
}
