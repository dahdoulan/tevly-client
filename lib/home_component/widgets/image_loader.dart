import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class ImageLoaderService {
  static Future<String?> loadImage(int movieId) async {
    try {
      final token = AuthenticationService().getToken();
      if (token == null) {
        Logger.debug('Authentication token is null');
        return null;
      }

      final thumbnailUrl = Uri.parse('${ApiConstants.baseUrl}/videos/$movieId/thumbnail');
      Logger.debug('Requesting thumbnail from: $thumbnailUrl');

      final response = await http.get(
        thumbnailUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final base64Image = base64Encode(response.bodyBytes);
        return 'data:image/jpeg;base64,$base64Image';
      } else {
        Logger.debug('Failed to fetch thumbnail: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Logger.debug('Error loading image: $e');
      return null;
    }
  }
}