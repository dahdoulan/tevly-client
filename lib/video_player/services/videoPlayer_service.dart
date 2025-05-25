import 'package:tevly_client/commons/logger/logger.dart';
import 'package:tevly_client/home_component/models/encoded_movie.dart';
import 'package:tevly_client/home_component/services/movie_service.dart';

class VideoService {
  final MovieService _movieService = MovieService();
  
  Future<Map<String, String>> loadVideoUrls(int movieId) async {
    Map<String, String> resolutionUrls = {};
    
    try {
      final encodedMovie = await _movieService.loadEncoded(movieId);
      Logger.debug('Received encoded movie data: $encodedMovie');

      if (encodedMovie is List) {
        for (var movie in encodedMovie) {
          _processEncodedMovie(movie, resolutionUrls);
        }
      } else if (encodedMovie is EncodedMovie) {
        _processEncodedMovie(encodedMovie, resolutionUrls);
      }

      Logger.debug('Available resolutions: ${resolutionUrls.keys.join(", ")}');
      return resolutionUrls;
    } catch (e, stackTrace) {
      Logger.debug('Error loading video URLs: $e');
      Logger.debug('Stack trace: $stackTrace');
      rethrow;
    }
  }

  void _processEncodedMovie(EncodedMovie movie, Map<String, String> resolutionUrls) {
    String title = movie.title.toLowerCase();
    String url = movie.url;
    
    if (title.contains('720p')) {
      resolutionUrls['720p'] = url;
    } else if (title.contains('1080p')) {
      resolutionUrls['1080p'] = url;
    }
  }
}