import 'package:tevly_client/auth_components/api/api_constants.dart';

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

class EncodedMovie {
  final int id;
  final String url;
  final String title;
  final Movie video;

  EncodedMovie({
    required this.id,
    required this.url,
    required this.title,
    required this.video,
  });

  factory EncodedMovie.fromJson(Map<String, dynamic> json) {
    return EncodedMovie(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      video: Movie.fromJson(json['video']),
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
  final int filmmakerId;
  final DateTime? createdAt;
  final int averageRating;
  final int userRating;

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
    this.filmmakerId = 0,
    this.createdAt,
    this.averageRating = 0,
    this.userRating = 0,
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
      filmmakerId: json['filmmakerId']?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      averageRating: json['averageRating']?.toInt() ?? 0,
      userRating: json['userRating']?.toInt() ?? 0,
    );
  }
}
