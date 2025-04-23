
import 'package:app_livros/app/models/livros.dart';

abstract class ListarLivrosState {}

class ListarLivrosInitial extends ListarLivrosState {}

class ListarLivrosCarregando extends ListarLivrosState {}

class ListarLivrosSucesso extends ListarLivrosState {
  final List<Book> livros;
  final List<Book> livrosSalvos;

  ListarLivrosSucesso({required this.livros, this.livrosSalvos = const []});
}

class ListarLivrosFalha extends ListarLivrosState {
  final String erro;

  ListarLivrosFalha({required this.erro});
}