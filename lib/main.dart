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

      // NOTA: Recorremos la lista jsonData del elemento Data.
      for (var item in jsonData['data']) {
        gifs.add(Gif(item['title'], item['images']['downsized']['url']));
      }

      return gifs;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          // NOTA: A continuacion el -snapshot- recoge la información del future
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listGifs(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

// NOTA: Creamos una lista de Text y la devolvemos.
  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(
        Card(
            child: Column(
          children: [
            Expanded(
              child: Image.network(
                gif.url,
                fit: BoxFit.fill,
              ),
            ),
          ],
        )),
      );
    }
    return gifs;
  }
}
