import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class AdminDashboardService {
  final String? token = AuthenticationService().getToken();

  Future<List<Map<String, dynamic>>> fetchPendingMovies() async {
    if (token == null) throw Exception('No authentication token found');

    final response = await http.post(
      Uri.parse(ApiConstants.adminPendingMovies),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load pending movies');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRejectedMovies() async {
    if (token == null) throw Exception('No authentication token found');

    final response = await http.post(
      Uri.parse(ApiConstants.rejectedMovieList),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> rejectedData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(rejectedData);
    } else {
      throw Exception('Failed to load pending movies');
    }
  }

  Future<void> approveMovie(int videoId) async {
    if (token == null) throw Exception('No authentication token found');

    Logger.debug('Approving movie with ID: $videoId');
    final url = Uri.parse('${ApiConstants.approveMovie}?videoId=$videoId');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve movie: ${response.statusCode}');
    }
  }

  Future<void> rejectMovie(int videoId) async {
    if (token == null) throw Exception('No authentication token found');

    Logger.debug('Rejecting movie with ID: $videoId');
    final url = Uri.parse('${ApiConstants.rejectMovie}?videoId=$videoId');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject movie: ${response.statusCode}');
    }
  }
}