import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../domain/entities/city.dart';
import '../../../domain/repositories/city_repo.dart';
import '../../dtos/city_dto.dart';

class JsonCityLocalRepo implements ICityRepo {
  @override
  Stream<List<City>> getCities() async* {
    final String response = await rootBundle.loadString('assets/cities.json');
    final data = List<Map<String, dynamic>>.from(await json.decode(response));
    yield data.map(CityDTO.fromMap).toList();
  }
}
