// lib/providers/movie_provider.dart
import 'package:flutter/foundation.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _allMovies = [];
  List<Movie> _myList = [];
  bool _isLoading = false;

  // Getters
  List<Movie> get allMovies => _allMovies;
  List<Movie> get actionMovies =>
      _allMovies.where((movie) => movie.category == 'Action').toList();
  List<Movie> get horrorMovies =>
      _allMovies.where((movie) => movie.category == 'Horror').toList();
  List<Movie> get myList => _myList;
  bool get isLoading => _isLoading;

  // Fetch movies from backend
  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allMovies = await _movieService.fetchMovies();
    } catch (e) {
      Logger.debug('Error in fetchMovies: $e');
      // You might want to show an error message to the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to My List
  void addToMyList(Movie movie) {
    if (!_myList.any((item) => item.id == movie.id)) {
      _myList.add(movie);
      notifyListeners();
    }
  }

  // Remove from My List
  void removeFromMyList(int movieId) {
    _myList.removeWhere((movie) => movie.id == movieId);
    notifyListeners();
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
