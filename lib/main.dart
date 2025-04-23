// main.dart
import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/modules/auth/auth_bloc.dart';
import 'package:app_livros/app/modules/livros/livro_bloc.dart';
import 'package:app_livros/app/page_screen/cadastro_loja.dart';
import 'package:app_livros/app/page_screen/home_page.dart';
import 'package:app_livros/app/page_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(apiService: ApiService()),
        ),
        BlocProvider<ListarLivrosBloc>(
          create: (context) => ListarLivrosBloc(
            apiService: ApiService(),
            authBloc: BlocProvider.of<AuthBloc>(context),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBookStore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Tela inicial ainda é LoginPage
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => CatalogoScreen(apiService: ApiService()),
        '/cadastrar-loja': (context) => CadastrarLojaScreen(), // Adicione esta rota
        // Outras rotas da sua aplicação
      },
    );
  }
}