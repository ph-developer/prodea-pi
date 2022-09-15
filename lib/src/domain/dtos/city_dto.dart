import '../entities/city.dart';

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

  String get value => "$name/$uf";
}
