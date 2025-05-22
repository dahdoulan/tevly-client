import 'package:tevly_client/home_component/models/movie.dart';

class EncodedMovie {
  final int id;
  final String url;
  final String title;
  final Movie? video;

  EncodedMovie({
    required this.id,
    required this.url,
    required this.title,
    this.video,
  });

  factory EncodedMovie.fromJson(Map<String, dynamic> json) {
    return EncodedMovie(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      video: json['video'] != null ? Movie.fromJson(json['video']) : null,
    );
  }

  String get resolution {
    // Extract resolution from title (e.g., "720p" from "720p-31337ced...")
    return title.split('-').first;
  }
}