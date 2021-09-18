import 'package:flutter/material.dart';
import 'package:movies/src/modelos/pelicula_model.dart';
import 'package:movies/src/provider/peliculas_providers.dart';

class DataSearch extends SearchDelegate {
  @override
  final peliculasProvider = new PeliculasProvider();

  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Creacion de resultados a Mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que se muestran al escribir
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.buscarPeliculas(query),
        builder: (context, AsyncSnapshot<List<Pelicula>> data) {
          if (data.hasData) {
            final peliculas = data.data;

            return ListView(
                children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqID = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
