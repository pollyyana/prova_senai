import 'package:equatable/equatable.dart';

class Store extends Equatable {
  final int id;
  final String name;
  final String slogan;
  final String banner;

  const Store({
    required this.id,
    required this.name,
    required this.slogan,
    required this.banner,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['idStore'] ?? json['id'] ?? 0, // API pode usar 'idStore' ou 'id'
      name: json['name'] ?? '',
      slogan: json['slogan'] ?? '',
      banner: json['banner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slogan': slogan,
      'banner': banner,
    };
  }

  @override
  List<Object?> get props => [id, name, slogan, banner];
}