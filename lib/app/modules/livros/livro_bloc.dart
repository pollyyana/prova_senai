import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/models/livros.dart';
import 'package:app_livros/app/modules/auth/auth_bloc.dart';
import 'package:app_livros/app/modules/auth/auth_state.dart';
import 'package:app_livros/app/modules/livros/livro_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListarLivrosBloc extends Bloc<ListarLivrosEvent, ListarLivrosState> {
  final ApiService _apiService;
  final AuthBloc _authBloc;

  ListarLivrosBloc({required ApiService apiService, required AuthBloc authBloc})
      : _apiService = apiService,
        _authBloc = authBloc,
        super(ListarLivrosInitial()) {
    on<ListarLivrosCarregados>(_onListarLivrosCarregados);
    on<CarregarLivrosSalvos>(_onCarregarLivrosSalvos);
  }

  Future<void> _onListarLivrosCarregados(
    ListarLivrosCarregados event,
    Emitter<ListarLivrosState> emit,
  ) async {
    emit(ListarLivrosCarregando());
    try {
      if (_authBloc.state is AuthSuccess) {
        final storeId = (_authBloc.state as AuthSuccess).store.id;
        final dynamic livrosData = await _apiService.buscarLivros(storeId);
        List<Book> livros = [];
        if (livrosData is List) {
          livros = (livrosData as List<dynamic>)
              .map((json) => Book.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        emit(ListarLivrosSucesso(livros: livros, livrosSalvos: []));
        add(CarregarLivrosSalvos());
      } else {
        emit(
          ListarLivrosFalha(
            erro: 'Usuário não autenticado ou loja não encontrada.',
          ),
        );
      }
    } catch (e) {
      emit(ListarLivrosFalha(erro: e.toString()));
    }
  }

  Future<void> _onCarregarLivrosSalvos(
    CarregarLivrosSalvos event,
    Emitter<ListarLivrosState> emit,
  ) async {
    try {
      if (_authBloc.state is AuthSuccess) {
        final userId = (_authBloc.state as AuthSuccess).user?.id;
        if (userId != null) {
          final dynamic livrosSalvosData = await _apiService.buscarLivrosSalvos(
            userId,
          );
          List<Book> livrosSalvos = [];
          if (livrosSalvosData is List) {
            livrosSalvos = (livrosSalvosData as List<dynamic>)
                .map((json) => Book.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          final currentState = state;
          if (currentState is ListarLivrosSucesso) {
            emit(currentState.copyWith(livrosSalvos: livrosSalvos));
          }
        } else {
          print('ID do usuário não encontrado.');
        }
      } else {
        print('Usuário não autenticado para carregar livros salvos.');
      }
    } catch (e) {
      print('Erro ao carregar livros salvos: $e');
    }
  }
}

// Estenda o ListarLivrosSucesso para permitir a cópia com novos valores
extension ListarLivrosSucessoCopyWith on ListarLivrosSucesso {
  ListarLivrosSucesso copyWith({
    List<Book>? livros,
    List<Book>? livrosSalvos, // Certifique-se de que este parâmetro esteja aqui
  }) {
    return ListarLivrosSucesso(
      livros: livros ?? this.livros,
      livrosSalvos: livrosSalvos ?? this.livrosSalvos,
    );
  }
}