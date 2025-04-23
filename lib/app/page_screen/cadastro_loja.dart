import 'dart:io';
import 'dart:convert';
import 'package:app_livros/app/Api%20Service/api_service.dart';
import 'package:app_livros/app/models/store_model.dart';
import 'package:app_livros/app/models/user_model.dart';
import 'package:app_livros/app/modules/auth/auth_bloc.dart';
import 'package:app_livros/app/modules/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastrarLojaScreen extends StatefulWidget {
  const CadastrarLojaScreen({super.key});

  @override
  _CadastrarLojaScreenState createState() => _CadastrarLojaScreenState();
}

class _CadastrarLojaScreenState extends State<CadastrarLojaScreen> {
  final _nomeLojaController = TextEditingController();
  final _sloganController = TextEditingController();
  final _nomeAdminController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String? _base64Image;

  Future<void> _pickImage() async {
    print(
      'Botão de seleção de imagem clicado!',
    ); // VERIFICA SE A FUNÇÃO É CHAMADA
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _convertToBase64();
      } else {
        print('Nenhuma imagem selecionada.');
      }
    });
  }

  void _convertToBase64() async {
    print(
      'Imagem selecionada, convertendo para Base64...',
    ); // VERIFICA SE A FUNÇÃO É CHAMADA
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      _base64Image = base64Encode(bytes);
      print(
        'Imagem convertida para Base64: ${_base64Image?.substring(0, 50)}...',
      ); // VERIFICA A CONVERSÃO
    } else {
      _base64Image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar loja')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeLojaController,
                decoration: InputDecoration(labelText: 'Nome da loja'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _sloganController,
                decoration: InputDecoration(labelText: 'Slogan da loja'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Selecionar Banner da Loja'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nomeAdminController,
                decoration: InputDecoration(labelText: 'Nome do administrador'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _senhaController,
                // obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                validator:
                    (value) =>
                        value!.length < 6
                            ? 'A senha deve ter pelo menos 6 caracteres'
                            : null,
              ),
              TextFormField(
                controller: _repetirSenhaController,
                // obscureText: true,
                decoration: InputDecoration(labelText: 'Repetir senha'),
                validator:
                    (value) =>
                        value != _senhaController.text
                            ? 'As senhas não coincidem'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  print('Botão "Salvar" clicado!');

                  if (_formKey.currentState!.validate()) {
                    // final lojaData = {
                    //   'name': _nomeLojaController.text,
                    //   'slogan': _sloganController.text,
                    //   'banner': _base64Image,
                    //   'user': _nomeAdminController.text,
                    //   'password': _senhaController.text,
                    // };
                    final lojaData = {
                      'name': _nomeLojaController.text,
                      'slogan': _sloganController.text,
                      'banner': _base64Image,
                      'admin': {
                        'name': _nomeAdminController.text,
                        'username':
                            _nomeAdminController
                                .text, // Ou um campo de username separado
                        'password': _senhaController.text,
                      },
                    };

                    print(
                      'Dados da loja a serem enviados (criados): $lojaData',
                    );

                    // Salvar no SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    final lojaDataJson = jsonEncode(lojaData);
                    await prefs.setString('lojaDataParaEnviar', lojaDataJson);

                    // Ler do SharedPreferences
                    final storedLojaDataJson = prefs.getString(
                      'lojaDataParaEnviar',
                    );
                    Map<String, dynamic>? storedLojaData;
                    if (storedLojaDataJson != null) {
                      storedLojaData =
                          jsonDecode(storedLojaDataJson)
                              as Map<String, dynamic>;
                      print(
                        'Dados da loja lidos do SharedPreferences: $storedLojaData',
                      );
                    } else {
                      print('Erro ao ler dados do SharedPreferences!');
                      return; // Interrompe se não conseguir ler
                    }

                    try {
                      final response = await apiService.criarLoja(
                        storedLojaData!,
                      );
                      print('Resposta ao criar loja: $response');

                      // ... (restante do seu código para lidar com a resposta)
                    } catch (error) {
                      print('Erro ao criar loja: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao criar loja: $error')),
                      );
                    }
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeLojaController.dispose();
    _sloganController.dispose();
    _nomeAdminController.dispose();
    _senhaController.dispose();
    _repetirSenhaController.dispose();
    super.dispose();
  }
}
