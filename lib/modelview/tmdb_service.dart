import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Movie.dart';

class TMDbService {
  final String apiKey = '4b90f6374ce7f09c420c68b758cabf70';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR'));

    if (response.statusCode == 200) {
      List<Movie> movies = [];
      var jsonResponse = jsonDecode(response.body);
      for (var movieJson in jsonResponse['results']) {
        Movie movie = await fetchMovieDetails(movieJson['id']);
        movies.add(movie);
      }
      return movies;
    } else {
      throw Exception('Falha ao carregar filmes populares');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=videos&language=pt-BR'));

    if (response.statusCode == 200) {
      var movieJson = jsonDecode(response.body);

      List<String> genres = [];
      for (var genreJson in movieJson['genres']) {
        genres.add(genreJson['name']);
      }

      String? trailerUrl;
      for (var videoJson in movieJson['videos']['results']) {
        if (videoJson['site'] == 'YouTube') {
          trailerUrl = 'https://www.youtube.com/watch?v=${videoJson['key']}';
          break;
        }
      }

      return Movie(
        title: movieJson['title'],
        synopsis: movieJson['overview'],
        rating: movieJson['vote_average'].toDouble(),
        genres: genres,
        duration: Duration(minutes: movieJson['runtime'] ?? 0),
        releaseDate: DateTime.parse(movieJson['release_date']),
        urlCover: '$imageBaseUrl${movieJson['poster_path']}',
        urlTrailer: trailerUrl ?? '',
      );
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }
}
