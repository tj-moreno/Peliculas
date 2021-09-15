import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/modelos/actor_model.dart';
import 'package:movies/src/modelos/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '33f4dcc5a7d6031c38b94e401127927f';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularespage = 0;

  List<Pelicula> _populares = new List();

  bool _isLoading = false;

  final _streamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _streamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _streamController.stream;

  void disponseStreams() {
    _streamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _conectToProvider(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_isLoading) return [];

    _isLoading = true;

    _popularespage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularespage.toString()
    });

    final _resp = await _conectToProvider(url);

    _populares.addAll(_resp);
    popularesSink(_populares);

    _isLoading = false;

    return _resp;
  }

  Future<List<Actor>> getCast(String peliculaID) async {
    final url = Uri.https(_url, '3/movie/$peliculaID/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);

    final decodeData = json.decode(resp.body);
    final reparto = new Cast.fromJsonList(decodeData['cast']);

    return reparto.actores;
  }

  Future<List<Pelicula>> _conectToProvider(Uri url) async {
    final resp = await http.get(url);

    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }
}
