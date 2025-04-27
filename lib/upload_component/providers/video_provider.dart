import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/upload_component/constants/api_constants.dart';
import 'package:tevly_client/upload_component/models/uploaded_video.dart';

import 'package:http/http.dart' as http;

class VideoUploadProvider extends ChangeNotifier {
  List<UploadedVideo> _videos = [];
  final List<String> _categories = [
    'Horror',
    'Action',
    'Adventure',
    'Comedy',
    'Crime and mystery',
    'Fantasy',
    'Historical',
    'Romance',
    'Science fiction',
    'Thriller',
    'Animation',
    'Drama',
    'Western',
    'documentary',
    'Other',
  ];
  String _selectedCategory = 'Other';

  dynamic _selectedThumbnail;
  String _thumbnailMime = '';

  late DropzoneViewController _dropzoneController;
  late DropzoneViewController
      _thumbnailDropzoneController; // Added separate controller for thumbnail
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isDragging = false;
  bool _isUploading = false;

  List<UploadedVideo> get videos => _videos;

  Future<void> handleDrop(
      dynamic event, String title, String description) async {
    final name = event.name;
    final mime = await _dropzoneController.getFileMIME(event);
    final size = await _dropzoneController.getFileSize(event);
    final url = await _dropzoneController.createFileUrl(event);
    final file = await _dropzoneController.getFileData(event);

    _videos.add(UploadedVideo(
      title: title.isNotEmpty ? title : name,
      description: description.isNotEmpty ? description : 'No description',
      mime: mime,
      size: size,
      url: url,
      file: file,
      category: _selectedCategory,
      thumbnail: _selectedThumbnail,
      thumbnailMime: _thumbnailMime,
    ));
    isDragging = false;
  }

  Future<void> handleThumbnailDrop(dynamic event) async {
    try {
      // Use the thumbnail controller instead of the video controller
      final mime = await _thumbnailDropzoneController.getFileMIME(event);
      if (!mime.startsWith('image/')) {
        throw Exception('Please upload an image file for thumbnail');
      }
      _selectedThumbnail =
          await _thumbnailDropzoneController.getFileData(event);
      _thumbnailMime = mime;
      isDragging = false;
      notifyListeners();
    } catch (e) {
      _selectedThumbnail = null;
      _thumbnailMime = '';
      isDragging = false;
      rethrow;
    }
  }

  Future<void> uploadVideos() async {
    isUploading = true;
    final url = Uri.parse(uploadUrl);
    for (var video in _videos) {
      final request = _createRequest(url, video);
      isUploading = true;
      try {
        await request.send();
      } catch (e) {
        Logger.error('Error uploading video: $e');
        isUploading = false;
        rethrow;
      }
      isUploading = false;
    }
    videos = [];
  }

  http.MultipartRequest _createRequest(Uri url, UploadedVideo video) {
    final request = http.MultipartRequest('POST', url)
      ..fields['description'] = video.description
      ..fields['title'] = video.title
      ..fields['category'] = video.category
      ..files.add(
        http.MultipartFile.fromBytes(
          'video',
          video.file,
          filename: '${video.title}.mp4',
          contentType: MediaType.parse(video.mime),
        ),
      )
      ..files.add(
        http.MultipartFile.fromBytes(
          'thumbnail',
          video.thumbnail,
          filename: '${video.title}_thumbnail.jpg',
          contentType: MediaType.parse(video.thumbnailMime),
        ),
      );
    return request;
  }

  void removeVideo(int index) {
    _videos.removeAt(index);
    notifyListeners();
  }

  void clearTextControllers() {
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  set isDragging(bool value) {
    _isDragging = value;
    notifyListeners();
  }

  set isUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  set videos(List<UploadedVideo> value) {
    _videos = value;
    notifyListeners();
  }

  void setDropzoneController(DropzoneViewController controller) {
    _dropzoneController = controller;
    notifyListeners();
  }

  // Added new method for setting the thumbnail dropzone controller
  void setThumbnailDropzoneController(DropzoneViewController controller) {
    _thumbnailDropzoneController = controller;
    notifyListeners();
  }

  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  dynamic get selectedThumbnail => _selectedThumbnail;
  String get thumbnailMime => _thumbnailMime;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isDragging => _isDragging;
  bool get isUploading => _isUploading;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
}
