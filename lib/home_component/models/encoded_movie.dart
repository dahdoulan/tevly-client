import 'package:tevly_client/commons/logger/logger.dart';

class EncodedMovie {
  final int id;
  final String url;
  final String title;
  final Map<String, dynamic>? video;

  EncodedMovie({
    required this.id,
    required this.url,
    required this.title,
    this.video,
  });

  factory EncodedMovie.fromJson(Map<String, dynamic> json) {
    try {
      return EncodedMovie(
        id: json['id'] as int,
        url: (json['url'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        video: json['video'] as Map<String, dynamic>?,
      );
    } catch (e, stackTrace) {
      Logger.debug('Error parsing EncodedMovie: $e');
      Logger.debug('JSON data: $json');
      Logger.debug('Stack trace: $stackTrace');
      throw FormatException('Failed to parse EncodedMovie: $e');
    }
  }

  @override
  String toString() {
    return 'EncodedMovie(id: $id, title: $title, url: $url)';
  }
}