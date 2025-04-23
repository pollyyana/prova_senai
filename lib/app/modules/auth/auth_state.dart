import 'package:app_livros/app/models/store_model.dart';
import 'package:app_livros/app/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final String refreshToken;
  final User user;
  final Store store;

  AuthSuccess({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.store,
  });
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

class AuthLoggedOut extends AuthState {} // Estado emitido após o logout