import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/modules/auth/auth_bloc.dart';
import 'package:app_livros/app/modules/auth/auth_event.dart';
import 'package:app_livros/app/modules/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(apiService: ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // Navegar para a tela principal usando a rota '/home'
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro de login: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // Adicionei um pequeno espaço
                  Text(
                    'Lembre-se: "user": "julio.bitencourt", "password": "8ec4sJ7dx!*d"',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null // Desabilita o botão durante o carregamento
                        : () {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginRequested(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ),
                            );
                          },
                    child: state is AuthLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Entrar'),
                  ),
                  SizedBox(height: 16), // Espaço entre os botões
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastrar-loja');
                    },
                    child: Text('Cadastrar nova loja', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}