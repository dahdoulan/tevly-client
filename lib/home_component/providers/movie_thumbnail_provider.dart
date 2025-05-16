import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/widgets/image_loader.dart';
 
class MovieThumbnailProvider extends ChangeNotifier {
  static final Map<int, String> _imageCache = {}; // In-memory cache for images
  String? _base64Image;
  bool _isLoading = true;

  String? get base64Image => _base64Image;
  bool get isLoading => _isLoading;

  Future<void> loadThumbnail(int movieId) async {
    // Check if the image is already cached
    if (_imageCache.containsKey(movieId)) {
      _base64Image = _imageCache[movieId];
      _isLoading = false;
      notifyListeners();
      return;
    }

    // If not cached, fetch the image
    final base64Image = await ImageLoaderService.loadImage(movieId);
    if (base64Image != null) {
      _imageCache[movieId] = base64Image; // Cache the image
      _base64Image = base64Image;
    }
    _isLoading = false;
    notifyListeners();
  }
}