// lib/providers/movie_provider.dart
import 'package:flutter/foundation.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  final VideoUploadProvider _videoUploadProvider = VideoUploadProvider();

  List<Movie> _allMovies = [];
  List<Movie> _myList = [];
  bool _isLoading = false;
  Map<int, String> _thumbnailCache = {};

  // Getters
  List<Movie> get allMovies => _allMovies;
  List<Movie> get myList => _myList;
  bool get isLoading => _isLoading;
  List<String> get categories => _videoUploadProvider.categories;

  // Get cached thumbnail
  String? getThumbnailUrl(int movieId) => _thumbnailCache[movieId];

  // Cache thumbnail URL
  void cacheThumbnailUrl(int movieId, String url) {
    _thumbnailCache[movieId] = url;
    // Remove immediate notification to prevent build-time updates
    Future.microtask(() => notifyListeners());
  }

  // Fetch movies if not already loaded
    Future<void> fetchMovies({bool forceRefresh = false}) async {
    if (!forceRefresh && allMovies.isNotEmpty) return;

    _isLoading = true;
    // Use microtask for state updates
    Future.microtask(() => notifyListeners());

    try {
      _allMovies = await _movieService.fetchMovies();
    } catch (e) {
      Logger.debug('Error fetching movies: $e');
    } finally {
      _isLoading = false;
      // Use microtask for state updates
      Future.microtask(() => notifyListeners());
    }
  }

  // Add to My List
  void addToMyList(Movie movie) {
    if (!_myList.any((item) => item.id == movie.id)) {
      _myList.add(movie);
      Future.microtask(() => notifyListeners());
    }
  }
  // Remove from My List
  void removeFromMyList(int movieId) {
    _myList.removeWhere((movie) => movie.id == movieId);
    Future.microtask(() => notifyListeners());
  }
  List<Movie> getMoviesByCategory(String category) {
    return _allMovies.where((movie) => movie.category == category).toList();
  }
 List<Movie> getAllMoviesByCategory(String category) {
    return _allMovies.where((movie) => movie  == movie).toList();
  }
  // Toggle My List
  void toggleMyList(Movie movie) {
    if (_myList.any((item) => item.id == movie.id)) {
      removeFromMyList(movie.id);
    } else {
      addToMyList(movie);
    }
  }

  // Check if movie is in My List
  bool isInMyList(int movieId) {
    return _myList.any((movie) => movie.id == movieId);
  }
}
