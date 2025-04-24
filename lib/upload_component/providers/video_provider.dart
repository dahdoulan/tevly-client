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

  late DropzoneViewController _dropzoneController;
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
    ));
    isDragging = false;
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
      ..fields['title'] = video.title
      ..fields['description'] = video.description
      ..fields['category'] = video.category
      ..files.add(
        http.MultipartFile.fromBytes(
          'video',
          video.file,
          filename: video.title,
          contentType: MediaType.parse(video.mime),
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

  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isDragging => _isDragging;
  bool get isUploading => _isUploading;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
}
