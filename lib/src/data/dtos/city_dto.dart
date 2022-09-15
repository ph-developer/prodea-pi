import '../../domain/entities/city.dart';

extension CityDTO on City {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uf': uf,
    };
  }

  static City fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'],
      uf: map['uf'],
    );
  }
}
