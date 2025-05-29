class PendingMovie {
  final String title;
  final String uploadedBy;
  final String description;
  final String thumbnailUrl;
  final String movieUrl;
  final String date;
  final String status;

  PendingMovie({
    required this.title,
    required this.uploadedBy,
    required this.description,
    required this.thumbnailUrl,
    required this.movieUrl,
    required this.date,
    required this.status,
  });

  factory PendingMovie.fromJson(Map<String, dynamic> json) {
    return PendingMovie(
      title: json['title'] ?? '',
      uploadedBy: json['uploadedBy'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      movieUrl: json['movieUrl'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'ENCODED',
    );
  }
}
class RejectedMovie {
  final String title;
  final String uploadedBy;
  final String description;
  final String thumbnailUrl;
  final String movieUrl;
  final String date;
  final String status;

  RejectedMovie({
    required this.title,
    required this.uploadedBy,
    required this.description,
    required this.thumbnailUrl,
    required this.movieUrl,
    required this.date,
    required this.status,
  });

  factory RejectedMovie.fromJson(Map<String, dynamic> json) {
    return RejectedMovie(
      title: json['title'] ?? '',
      uploadedBy: json['uploadedBy'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      movieUrl: json['movieUrl'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'ENCODED',
    );
  }




  
}