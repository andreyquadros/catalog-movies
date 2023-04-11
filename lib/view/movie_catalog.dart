// ...
import 'package:flutter/material.dart';
import '../model/Movie.dart';
import '../modelview/tmdb_service.dart';
import 'components/movie_card.dart';


class MovieCatalog extends StatefulWidget {
  @override
  _MovieCatalogState createState() => _MovieCatalogState();
}

class _MovieCatalogState extends State<MovieCatalog> {
  List<Movie> movieList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      TMDbService tmdbService = TMDbService();
      movieList = await tmdbService.fetchPopularMovies();
    } catch (e) {
      print('Erro ao carregar filmes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Catálogo de Filmes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Filme em destaque
          Expanded(
            flex: 3,
            child: MovieCard(movie: movieList[0]),
          ),
          // Lista de filmes
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: movieList.length - 1,
              itemBuilder: (BuildContext context, int index) {
                return MovieCard(movie: movieList[index + 1]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

