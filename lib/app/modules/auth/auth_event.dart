// auth_event.dart
import 'package:app_livros/app/models/store_model.dart';
import 'package:app_livros/app/models/user_model.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

class LogoutRequested extends AuthEvent {}

// Novo evento para indicar que a conta foi criada com sucesso
class AccountCreated extends AuthEvent {
  final String token;
  final String refreshToken;
  final User user;
  final Store store;

  AccountCreated({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.store,
  });
}