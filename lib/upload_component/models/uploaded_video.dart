class UploadedVideo {
  final String title;
  final String description;
  final String mime;
  final int size;
  final String url;
  final dynamic file;

  UploadedVideo({
    required this.title,
    required this.description,
    required this.mime,
    required this.size,
    required this.url,
    required this.file,
  });
}
