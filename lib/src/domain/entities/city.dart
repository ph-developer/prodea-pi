import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String uf;

  const City({
    required this.name,
    required this.uf,
  });

  @override
  List<Object?> get props => [
        name,
        uf,
      ];
}
