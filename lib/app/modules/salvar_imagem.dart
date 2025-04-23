import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class SalvarImagemLocalmente extends StatefulWidget {
  @override
  _SalvarImagemLocalmenteState createState() => _SalvarImagemLocalmenteState();
}

class _SalvarImagemLocalmenteState extends State<SalvarImagemLocalmente> {
  String? _imagemBase64;

  Future<void> _carregarSalvarImagem() async {
    final ByteData byteData = await rootBundle.load('assets/minha_imagem.png'); // Substitua pelo seu asset
    final Uint8List bytes = byteData.buffer.asUint8List();
    final String base64String = base64Encode(bytes);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bannerLoja', base64String); // Use uma chave significativa

    setState(() {
      _imagemBase64 = base64String;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imagem salva localmente!')),
    );
  }

  Future<void> _carregarImagemSalva() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? base64String = prefs.getString('bannerLoja');
    setState(() {
      _imagemBase64 = base64String;
    });
  }

  Uint8List _decodificarBase64(String base64String) {
    return base64Decode(base64String);
  }

  Widget _exibirImagem() {
    if (_imagemBase64 != null) {
      final Uint8List bytes = _decodificarBase64(_imagemBase64!);
      return Image.memory(bytes);
    } else {
      return Text('Nenhuma imagem salva.');
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarImagemSalva(); // Tenta carregar a imagem salva ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salvar Imagem Localmente'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _exibirImagem(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _carregarSalvarImagem,
              child: Text('Salvar Banner da Loja'),
            ),
          ],
        ),
      ),
    );
  }
}