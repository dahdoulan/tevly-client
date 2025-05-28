import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/movie.dart';
import 'package:tevly_client/home_component/services/cache_service.dart';

class SearchService {
  final MovieCacheService _cacheService = MovieCacheService();

  Future<List<Movie>> fetchAllMovies() async {
    try {
      if (_cacheService.isCacheValid) {
        Logger.debug("Using cached movies");
        return _cacheService.getCachedMovies();
      }

      final token = await AuthenticationService().getToken();
      final response = await http.post(
        Uri.parse(ApiConstants.metadata),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      Logger.debug("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final movies = data.map((json) => Movie.fromJson(json)).toList();
        _cacheService.updateCache(movies);
        return movies;
      } else {
        throw Exception("Failed to fetch movies: ${response.statusCode}");
      }
    } catch (e) {
      Logger.debug("Error fetching movies: $e");
      return [];
    }
  }
}