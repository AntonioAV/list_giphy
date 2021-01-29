import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:list_giphy/models/gif.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // NOTA: Nueva variable a futuro.
  Future<List<Gif>> _listadoGifs;

  /// NOTA:Creamos una función que nos devuelva un objeto de ese tipo.

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(
        'https://api.giphy.com/v1/gifs/trending?api_key=IKWoE5xam68OPf5vK8zZwiiKx8SEj9cc&limit=10&rating=g');

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      /// NOTA: Evitamos que los carácteres latinos se vean extraños.
      String body = utf8.decode(response.bodyBytes);

      // NOTA: Convertimos el sting body en un objeto Json.

      final jsonData = jsonDecode(body);
    } else {
      throw Exception('Falló la conexión');
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
