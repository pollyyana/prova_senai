import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/models/store_model.dart';
import 'package:app_livros/app/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    // Define o que acontece quando o evento LoginRequested é adicionado ao BLoC
    on<LoginRequested>(_onLoginRequested);
    // Define o que acontece quando o evento LogoutRequested é adicionado ao BLoC
    on<LogoutRequested>(_onLogoutRequested);
    // Define o que acontece quando o evento AppStarted é adicionado ao BLoC (geralmente na inicialização do app)
    on<AppStarted>(_onAppStarted);
    // Define o que acontece quando o evento AccountCreated é adicionado ao BLoC (para lidar com a criação de nova conta/loja)
    on<AccountCreated>(_onAccountCreated); // Nova linha adicionada
  }

  // Função para salvar o token de autenticação localmente usando SharedPreferences
  Future<void> _salvarToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Função para ler o token de autenticação salvo localmente usando SharedPreferences
  Future<String?> _lerToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Lógica para quando o aplicativo é iniciado
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final String? token = await _lerToken();
    // Se um token estiver salvo localmente, emite o estado de sucesso (sem buscar novas informações por enquanto)
    if (token != null) {
      emit(AuthSuccess(token: token, refreshToken: '', user: const User(id: 0, name: '', photo: '', role: ''), store: const Store(id: 0, name: '', slogan: '', banner: '')));
    } else {
      // Se não houver token salvo, emite o estado de logout
      emit(AuthLoggedOut());
    }
  }

  // Lógica para quando uma requisição de login é feita
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    // Emite o estado de carregamento para indicar que o login está em andamento
    emit(AuthLoading());
    try {
      // Chama o serviço da API para autenticar o usuário
      final authResponse = await apiService.autenticarUsuario(event.username, event.password);
      // Extrai o token da resposta
      final token = authResponse['token'] as String;
      // Extrai o refreshToken da resposta
      final refreshToken = authResponse['refreshToken'] as String;
      // Extrai as informações do usuário da resposta (se existirem)
      final user = authResponse['user'] != null ? User.fromJson(authResponse['user']) : const User(id: 0, name: '', photo: '', role: '');
      // Extrai as informações da loja da resposta (se existirem)
      final store = authResponse['store'] != null ? Store.fromJson(authResponse['store']) : const Store(id: 0, name: '', slogan: '', banner: '');

      // Define o token de autenticação no serviço da API para futuras requisições
      apiService.setAuthToken(token);
      // Salva o token localmente
      await _salvarToken(token);

      // Imprime o token no console para fins de depuração
      print('Token recebido após o login: $token');

      // Emite o estado de sucesso do login com as informações recebidas
      emit(AuthSuccess(token: token, refreshToken: refreshToken, user: user, store: store));
    } catch (e) {
      // Emite o estado de falha do login com a mensagem de erro
      emit(AuthFailure(error: e.toString()));
    }
  }

  // Lógica para quando uma requisição de logout é feita
  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    // Limpa o token no serviço da API
    apiService.setAuthToken(null);
    // Remove o token localmente
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    // Emite o estado de logout
    emit(AuthLoggedOut());
  }

  // Lógica para quando uma conta é criada (ou loja cadastrada com sucesso)
  Future<void> _onAccountCreated(AccountCreated event, Emitter<AuthState> emit) async {
    // Define o token de autenticação no serviço da API
    apiService.setAuthToken(event.token);
    // Salva o token localmente
    await _salvarToken(event.token);
    // Emite o estado de sucesso do login com as informações recebidas
    emit(AuthSuccess(
      token: event.token,
      refreshToken: event.refreshToken,
      user: event.user,
      store: event.store,
    ));
  }
}