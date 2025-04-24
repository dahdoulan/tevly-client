import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/ApiConstants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class ImageLoaderService {
  static Future<String?> loadImage(int movieId) async {
    if (!kIsWeb) {
      return null; // Mobile devices will handle the URL directly
    }

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
          'Accept': 'image/jpeg, image/png, image/*',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Cache-Control': 'no-cache',
          'Access-Control-Allow-Origin': '*',
        },
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      Logger.debug('Response status: ${response.statusCode}');
      Logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 200 && !response.body.contains('DOCTYPE')) {
        final base64Image = base64Encode(response.bodyBytes);
        return 'data:image/jpeg;base64,$base64Image';
      } else {
        Logger.debug('Invalid response type or error: ${response.body.substring(0, Math.min(100, response.body.length))}');
        return null;
      }
    } catch (e, stackTrace) {
      Logger.debug('Error loading image: $e');
      Logger.debug('Stack trace: $stackTrace');
      return null;
    }
  }
}