class UploadedVideo {
  final String title;
  final String description;
  final String mime;
  final int size;
  final String url;
  final dynamic file;
  final String category;
  final dynamic thumbnail; // Add thumbnail field
  final String thumbnailMime; // Add thumbnail mime type

  UploadedVideo({
    required this.title,
    required this.description,
    required this.mime,
    required this.size,
    required this.url,
    required this.file,
    required this.category,
    required this.thumbnail,
    required this.thumbnailMime,
  });
}
