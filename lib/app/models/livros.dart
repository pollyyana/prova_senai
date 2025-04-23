import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String cover; // <--- Campo para a URL da capa
  final String title;
  final String author;
  final String synopsis;
  final int year;
  final double rating;
  final bool available; // <--- Campo para o status de disponibilidade
  final int storeId;

  const Book({
    required this.id,
    required this.cover,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.year,
    required this.rating,
    required this.available,
    required this.storeId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      cover: json['cover'] ?? '', // <--- Mapeamento do JSON para o campo 'cover'
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      synopsis: json['synopsis'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      available: json['available'] ?? false, // <--- Mapeamento do JSON para o campo 'available'
      storeId: json['idStore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cover': cover,
      'title': title,
      'author': author,
      'synopsis': synopsis,
      'year': year,
      'rating': rating,
      'available': available,
      'idStore': storeId,
    };
  }

  @override
  List<Object?> get props => [id, cover, title, author, synopsis, year, rating, available, storeId];
}