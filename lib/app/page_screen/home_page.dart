import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/models/livros.dart';
import 'package:app_livros/app/modules/auth/auth_bloc.dart';
import 'package:app_livros/app/modules/livros/livro_bloc.dart';
import 'package:app_livros/app/modules/livros/livro_event.dart';
import 'package:app_livros/app/modules/livros/widget/book_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogoScreen extends StatelessWidget {
  final ApiService apiService;

  const CatalogoScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ListarLivrosBloc(
            apiService: apiService,
            authBloc: BlocProvider.of<AuthBloc>(context),
          )..add(ListarLivrosCarregados()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(Icons.book, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text('Olá, Nome do Usuário'),
              SizedBox(width: 8),
              Text('👋'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Buscar livros');
              },
            ),
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                print('Filtrar livros');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Livros salvos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                BlocBuilder<ListarLivrosBloc, ListarLivrosState>(
                  builder: (context, state) {
                    if (state is ListarLivrosSucesso) {
                      if (state.livrosSalvos.isNotEmpty) {
                        return SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.livrosSalvos.length,
                            itemBuilder: (context, index) {
                              final Book livro = state.livrosSalvos[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: SizedBox(
                                  width: 100,
                                  child: BookCard(book: livro),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                          height: 50,
                          child: Center(
                            child: Text('Nenhum livro salvo ainda.'),
                          ),
                        );
                      }
                    } else if (state is ListarLivrosCarregando) {
                      return SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Todos os livros',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                BlocBuilder<ListarLivrosBloc, ListarLivrosState>(
                  builder: (context, state) {
                    if (state is ListarLivrosSucesso) {
                      if (state.livros.isNotEmpty) {
                        return _buildTodosOsLivrosGrid(state.livros);
                      } else {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nenhum livro encontrado na loja.',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    } else if (state is ListarLivrosCarregando) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ListarLivrosFalha) {
                      return Center(
                        child: Text('Erro ao carregar livros: ${state.erro}'),
                      );
                    } else {
                      return Center(child: Text('Nenhum livro carregado.'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Funcionários',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Livros'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Meu perfil',
            ),
          ],
          onTap: (index) {
            print('Bottom navigation item $index tapped');
          },
        ),
      ),
    );
  }

  Widget _buildTodosOsLivrosGrid(List<Book> livros) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: livros.length,
      itemBuilder: (context, index) {
        final Book livro = livros[index];
        return BookCard(book: livro); // Use o BookCard aqui
      },
    );
  }
}