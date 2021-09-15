import 'package:flutter/material.dart';
import 'package:movies/src/modelos/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 400) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, index) => _objClick(context, peliculas[index]),
      ),
    );
  }

  Widget _objClick(BuildContext context, Pelicula pelicula) {
    return GestureDetector(
      child: _tarjeta(context, pelicula),
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

  _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqID = '${pelicula.id}-p';
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: pelicula.uniqID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Center(
            child: Text(
              pelicula.title,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  //List<Widget> _tarjetas(BuildContext context) {
  //  return peliculas.map((pelicula) {
  //    return Container(
  //      margin: EdgeInsets.only(right: 15.0),
  //      child: Column(
  //        children: [
  //          ClipRRect(
  //            borderRadius: BorderRadius.circular(20.0),
  //            child: FadeInImage(
  //              placeholder: AssetImage('assets/img/no-image.jpg'),
  //              image: NetworkImage(pelicula.getPosterImg()),
  //              fit: BoxFit.cover,
  //              height: 160.0,
  //            ),
  //          ),
  //          SizedBox(height: 5.0),
  //          Center(
  //            child: Text(
  //              pelicula.title,
  //              overflow: TextOverflow.ellipsis,
  //              style: Theme.of(context).textTheme.caption,
  //            ),
  //          )
  //        ],
  //      ),
  //    );
  //  }).toList();
  //}
}
