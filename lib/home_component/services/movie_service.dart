 import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';
import '../models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    final token = AuthenticationService().getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is missing.');
    }
    Logger.debug('Token: $token');
    final response = await http.post(
      Uri.parse(ApiConstants.metadata),
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger.debug('Response: ${response.body}');
    Logger.debug('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = json.decode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
 
}
