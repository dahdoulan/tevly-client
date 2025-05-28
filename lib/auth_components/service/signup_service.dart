import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/commons/logger/logger.dart';

class SignupService {
  Future<Map<String, dynamic>> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required DateTime? dateOfBirth,
   }) async {
    try {
      
      final url = Uri.parse(ApiConstants.signup);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'firstname': firstname.trim().toLowerCase(),
        'lastname': lastname.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
       }),
    );

      Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');

      if (response.statusCode == 202) {
        return {
          'success': true,
          'message': 'Signup Successful',
        };
      }
      
      return {
        'success': false,
        'message': 'Signup Failed: Check your details again',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
class FilmmakerSignupService {
  Future<Map<String, dynamic>> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required DateTime? dateOfBirth,
   }) async {
    try {
      
      final url = Uri.parse(ApiConstants.signupFilmmaker);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'firstname': firstname.trim().toLowerCase(),
        'lastname': lastname.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
       }),
    );

      Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');

      if (response.statusCode == 202) {
        return {
          'success': true,
          'message': 'Signup Successful',
        };
      }
      
      return {
        'success': false,
        'message': 'Signup Failed: Check your details again',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
  class AdminSignupService {
  Future<Map<String, dynamic>> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required DateTime? dateOfBirth,
   }) async {
    try {
      
      final url = Uri.parse(ApiConstants.adminSignup);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'firstname': firstname.trim().toLowerCase(),
        'lastname': lastname.trim().toLowerCase(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
       }),
    );

      Logger.debug('Status Code: ${response.statusCode}, Response: ${response.body}');

      if (response.statusCode == 202) {
        return {
          'success': true,
          'message': 'Signup Successful',
        };
      }
      
      return {
        'success': false,
        'message': 'Signup Failed: Check your details again',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  }
 