import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:flutter/material.dart';

class ListarLivrosScreen extends StatefulWidget {
  final int storeId;

  const ListarLivrosScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _ListarLivrosScreenState createState() => _ListarLivrosScreenState();
}

class _ListarLivrosScreenState extends State<ListarLivrosScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _livros = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    try {
      final livros = await _apiService.buscarLivros(widget.storeId);
      setState(() {
        _livros = livros;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Erro ao carregar livros: $error';
        _isLoading = false;
      });
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros da Loja ${widget.storeId}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _livros.isEmpty
                  ? Center(child: Text('Nenhum livro cadastrado nesta loja.'))
                  : ListView.builder(
                      itemCount: _livros.length,
                      itemBuilder: (context, index) {
                        final livro = _livros[index];
                        return ListTile(
                          title: Text(livro['title'] ?? 'Título não disponível'),
                          subtitle:
                              Text('Autor: ${livro['author'] ?? 'Autor não disponível'}'),
                        );
                      },
                    ),
    );
  }
}