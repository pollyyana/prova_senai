import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final String photo;
  final String username;

  const Employee({
    required this.id,
    required this.name,
    required this.photo,
    required this.username,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo,
      'username': username,
      // 'password': password, // Senha geralmente não é enviada de volta
    };
  }

  @override
  List<Object?> get props => [id, name, photo, username];
}