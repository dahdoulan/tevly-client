import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'dart:convert';
 import '../../auth_components/service/authenticationService.dart';

class CommentService {
  Future<void> submitComment(int videoId, String comment) async {
    final token = AuthenticationService().getToken();

    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.submitComments),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'videoId': videoId,
        'comment': comment,
      }),
    );

    if (response.statusCode != 202) {
      throw Exception('Failed to post comment: ${response.body}');
    }
  }
}
