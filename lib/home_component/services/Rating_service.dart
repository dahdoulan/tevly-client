import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../auth_components/api/api_constants.dart';
import '../../auth_components/service/authenticationService.dart';
import '../../commons/logger/logger.dart';

class RatingService {
  Future<void> submitRating(int videoId, int rating) async {
    final token = AuthenticationService().getToken();

    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.userRating),  
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'videoId':
            videoId,  
        'rating': rating,
      }),
    );

    Logger.debug('Rating response status: ${response.statusCode}');
    Logger.debug('Rating response body: ${response.body}');

    if (response.statusCode != 202){
      throw Exception('Failed to submit rating: ${response.body}');
    }
  }
}