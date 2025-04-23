import 'package:app_livros/app/models/livros.dart';

// Define a classe abstrata ListarLivrosEvent, que serve como base para todos os eventos relacionados à listagem de livros.
abstract class ListarLivrosEvent {}

// Define o evento ListarLivrosCarregados. Quando uma instância deste evento é adicionada ao ListarLivrosBloc,
// ela sinaliza que a lista de livros deve ser carregada. Esta classe não contém dados adicionais.
class ListarLivrosCarregados extends ListarLivrosEvent {}

// listar_livros_state.dart

// Define a classe abstrata ListarLivrosState, que serve como base para todos os estados do BLoC de listagem de livros.
abstract class ListarLivrosState {}

// Define o estado ListarLivrosInitial. Este é o estado inicial do BLoC quando ele é criado e antes de qualquer carregamento de livros.
class ListarLivrosInitial extends ListarLivrosState {}

// Define o estado ListarLivrosCarregando. Este estado é emitido pelo BLoC enquanto ele está buscando os livros (por exemplo, fazendo uma chamada à API).
// Geralmente, a interface do usuário exibe um indicador de carregamento quando o BLoC está neste estado.
class ListarLivrosCarregando extends ListarLivrosState {}

// Define o estado ListarLivrosSucesso. Este estado é emitido quando os livros são carregados com sucesso.
// Ele contém a lista de livros carregada (`List<Book> livros`), que pode ser usada para exibir os dados na interface do usuário.
class ListarLivrosSucesso extends ListarLivrosState {
  final List<Book> livros;

  ListarLivrosSucesso({required this.livros, required List livrosSalvos});

  get livrosSalvos => null;
}

// Define o estado ListarLivrosFalha. Este estado é emitido quando ocorre um erro durante o carregamento dos livros.
// Ele contém uma mensagem de erro (`String erro`) que descreve o problema e pode ser exibida ao usuário.
class ListarLivrosFalha extends ListarLivrosState {
  final String erro;

  ListarLivrosFalha({required this.erro});
}

class CarregarLivrosSalvos extends ListarLivrosEvent {} // Adicione esta linha
