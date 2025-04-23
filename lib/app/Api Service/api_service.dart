import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api-flutter-prova.hml.sesisenai.org.br/v1';
  String? authToken; // Para armazenar o token de acesso

  // Método para salvar o token após o login ou criação de loja
  void setAuthToken(String? token) {
    authToken = token;
  }

  // Helper function para adicionar headers de autorização
  Map<String, String> _getHeadersWithAuth() {
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  // 1. POST /v1/store (Criar uma Loja)
  Future<Map<String, dynamic>> criarLoja(Map<String, dynamic> lojaData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/store'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(lojaData),
    );
    return _processResponse(response, expectedStatusCode: 200); // Alterado para 200
  }

  // 2. POST /v1/auth (Login)
  Future<Map<String, dynamic>> autenticarUsuario(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user': username, 'password': password}),
    );
    final responseData = _processResponse(response);
    setAuthToken(responseData['token']); // Salva o token ao logar
    return responseData;
  }

  // 4. GET /v1/store/{id} (Obter Detalhes da Loja)
  Future<Map<String, dynamic>> obterDetalhesLoja(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/store/$id'),
      headers: _getHeadersWithAuth(),
    );
    return _processResponse(response);
  }

  // 5. PUT /v1/store/{id} (Atualizar Loja)
  Future<Map<String, dynamic>> atualizarLoja(int id, Map<String, dynamic> lojaData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/store/$id'),
      headers: _getHeadersWithAuth(),
      body: jsonEncode(lojaData),
    );
    return _processResponse(response);
  }

  // 6. POST /v1/store/{storeId}/employee (Adicionar Funcionário)
  Future<Map<String, dynamic>> criarFuncionario(int storeId, Map<String, dynamic> funcionarioData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/store/$storeId/employee'),
      headers: _getHeadersWithAuth(),
      body: jsonEncode(funcionarioData),
    );
    return _processResponse(response, expectedStatusCode: 201);
  }

  // 7. GET /v1/store/{storeId}/employee (Listar Funcionários)
  Future<List<dynamic>> listarFuncionarios(int storeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/store/$storeId/employee'),
      headers: _getHeadersWithAuth(),
    );
    return _processResponseList(response);
  }

  // 8. PUT /v1/store/{storeId}/employee/{employeeId} (Atualizar Funcionário)
  Future<Map<String, dynamic>> atualizarFuncionario(int storeId, int employeeId, Map<String, dynamic> funcionarioData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/store/$storeId/employee/$employeeId'),
      headers: _getHeadersWithAuth(),
      body: jsonEncode(funcionarioData),
    );
    return _processResponse(response);
  }

  // 9. DELETE /v1/store/{storeId}/employee/{employeeId} (Deletar Funcionário)
  Future<void> deletarFuncionario(int storeId, int employeeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/store/$storeId/employee/$employeeId'),
      headers: _getHeadersWithAuth(),
    );
    _processResponse(response, expectedStatusCode: 200); // Ou 204 No Content
  }

  // 10. POST /v1/store/{storeId}/book (Adicionar Livro)
  Future<Map<String, dynamic>> adicionarLivro(int storeId, Map<String, dynamic> livroData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/store/$storeId/book'),
      headers: _getHeadersWithAuth(),
      body: jsonEncode(livroData),
    );
    return _processResponse(response, expectedStatusCode: 201);
  }

  // 11. PUT /v1/store/{storeId}/book/{bookId} (Atualizar Livro)
  Future<Map<String, dynamic>> atualizarLivro(int storeId, int bookId, Map<String, dynamic> livroData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/store/$storeId/book/$bookId'),
      headers: _getHeadersWithAuth(),
      body: jsonEncode(livroData),
    );
    return _processResponse(response);
  }

  // 12. GET /v1/store/{storeId}/book/{bookId} (Obter Detalhes do Livro)
  Future<Map<String, dynamic>> obterDetalhesLivro(int storeId, int bookId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/store/$storeId/book/$bookId'),
      headers: _getHeadersWithAuth(),
    );
    return _processResponse(response);
  }

  // 13. DELETE /v1/store/{storeId}/book/{bookId} (Deletar Livro)
  Future<void> deletarLivro(int storeId, int bookId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/store/$storeId/book/$bookId'),
      headers: _getHeadersWithAuth(),
    );
    _processResponse(response, expectedStatusCode: 200); // Ou 204 No Content
  }

  // 14. GET /v1/store/{storeId}/book (Buscar Livros)
  Future<List<dynamic>> buscarLivros(int storeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/store/$storeId/book'),
      headers: _getHeadersWithAuth(),
    );
    return _processResponseList(response);
  }

  // NOVO: Função para buscar os livros salvos de um usuário
  Future<List<dynamic>> buscarLivrosSalvos(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/saved-books'), // Adapte o endpoint da sua API
      headers: _getHeadersWithAuth(), // Se a autenticação for necessária
    );
    return _processResponseList(response); // Use sua função para processar a resposta
  }

  // Helper function para processar respostas JSON bem-sucedidas
  dynamic _processResponse(http.Response response, {int expectedStatusCode = 200}) {
    if (response.statusCode == expectedStatusCode) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body; // Pode ser uma string simples de sucesso
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }

  // Helper function para processar respostas JSON que são listas
  List<dynamic> _processResponseList(http.Response response, {int expectedStatusCode = 200}) {
    if (response.statusCode == expectedStatusCode) {
      try {
        return jsonDecode(response.body) as List<dynamic>;
      } catch (e) {
        print('Erro ao decodificar lista JSON: $e');
        throw Exception('Erro ao decodificar lista JSON');
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }
}