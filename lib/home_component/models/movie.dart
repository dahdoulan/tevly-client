// lib/models/movie.dart
class Movie {
  final int id;
  final String title;
  final String category;
  final String videoUrl;
  final String description;
  final bool popularMovies;
  final bool trendingMovies;
  final String thumbnailUrl;

  Movie({
    required this.id,
    required this.title,
    required this.category,
    required this.videoUrl,
    required this.description,
    this.popularMovies = false,
    this.trendingMovies = false,
    required this.thumbnailUrl,
  });

  // Factory method to create a Movie object from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      description: json['description'],
    );
  }
}
