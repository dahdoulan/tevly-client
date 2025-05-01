class Episode {
  final int id;
  final int episodeNumber;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final Duration duration;

  Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      episodeNumber: json['episodeNumber'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
    );
  }
}