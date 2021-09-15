import 'package:flutter/material.dart';
import 'package:movies/src/modelos/actor_model.dart';
import 'package:movies/src/modelos/pelicula_model.dart';
import 'package:movies/src/provider/peliculas_providers.dart';

class PeliculasDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            _crearAppbar(pelicula),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.0),
                _posterTitulo(context, pelicula),
                _descipcionPelicula(pelicula),
                _listadeActores(pelicula)
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(pelicula.getBackgroundImg()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pelicula.title, style: Theme.of(context).textTheme.headline6
                  //overflow: TextOverflow.ellipsis,
                  ),
              Text(pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1
                  //overflow: TextOverflow.ellipsis
                  ),
              Row(
                children: [
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString())
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _descipcionPelicula(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _listadeActores(Pelicula pelicula) {
    final peliculasProvider = new PeliculasProvider();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Actores..',
              style: TextStyle(fontSize: 15.0),
            )),
        SizedBox(
          height: 0.20,
        ),
        FutureBuilder(
          future: peliculasProvider.getCast(pelicula.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _crearActoresPage(snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _crearActoresPage(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actores.length,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        pageSnapping: false,
        itemBuilder: (context, index) => _tarjetadelActor(actores[index]),
      ),
    );
  }

  Widget _tarjetadelActor(Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(actor.getFoto()),
                height: 150.0,
                fit: BoxFit.cover),
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
