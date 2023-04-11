class Movie {
  final String title;
  final String synopsis;
  final double rating;
  final List<String> genres;
  final Duration duration;
  final DateTime releaseDate;
  final String urlCover;
  final String urlTrailer;

  Movie({required this.title,
    required this.synopsis,
    required this.rating,
    required this.genres,
    required this.duration,
    required this.releaseDate,
    required this.urlCover,
    required this.urlTrailer});


}