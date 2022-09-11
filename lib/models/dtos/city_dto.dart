import 'package:prodea/models/city.dart';

extension CityDTO on City {
  City copyWith({
    String? name,
    String? uf,
  }) {
    return City(
      name: name ?? this.name,
      uf: uf ?? this.uf,
    );
  }

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

  String get value => "$name/$uf";
}
