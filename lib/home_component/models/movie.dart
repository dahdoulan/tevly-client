import 'package:tevly_client/auth_components/api/ApiConstants.dart';

class Comment {
  final String comment;
  final String fullName;
  final DateTime date;

  Comment({
    required this.comment,
    required this.fullName,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'],
      fullName: json['fullName'],
      date: DateTime.parse(json['date']),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String category;
  final String videoUrl;
  final String description;
  final bool popularMovies;
  final bool trendingMovies;
  final String thumbnailUrl;
  final List<Comment> comments;

  Movie({
    required this.id,
    required this.title,
    required this.category,
    required this.videoUrl,
    required this.description,
    this.popularMovies = false,
    this.trendingMovies = false,
    required this.thumbnailUrl,
    this.comments = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: '${ApiConstants.baseUrl}${json['thumbnailUrl']}',
      category: json['category'],
      description: json['description'],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((commentJson) => Comment.fromJson(commentJson))
              .toList() ??
          [],
    );
  }
}
