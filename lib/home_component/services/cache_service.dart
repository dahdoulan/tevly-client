import 'package:tevly_client/home_component/models/movie.dart';

class MovieCacheService {
  static final MovieCacheService _instance = MovieCacheService._internal();
  factory MovieCacheService() => _instance;
  MovieCacheService._internal();

  List<Movie>? _cachedMovies;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  bool get hasCachedMovies => _cachedMovies != null;
  
  bool get isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheExpiration;
  }

  List<Movie> getCachedMovies() {
    return _cachedMovies ?? [];
  }

  void updateCache(List<Movie> movies) {
    _cachedMovies = movies;
    _lastFetchTime = DateTime.now();
  }

  void clearCache() {
    _cachedMovies = null;
    _lastFetchTime = null;
  }
}