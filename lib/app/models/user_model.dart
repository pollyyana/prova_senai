import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String photo;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.photo,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, name, photo, role];
}