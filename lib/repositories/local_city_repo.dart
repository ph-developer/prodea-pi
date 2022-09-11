import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:prodea/models/city.dart';
import 'package:prodea/models/dtos/city_dto.dart';
import 'package:prodea/repositories/contracts/city_repo.dart';

class LocalCityRepo implements ICityRepo {
  @override
  Future<List<City>> getCities() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final data = List<Map<String, dynamic>>.from(await json.decode(response));

    return data.map(CityDTO.fromMap).toList();
  }
}
