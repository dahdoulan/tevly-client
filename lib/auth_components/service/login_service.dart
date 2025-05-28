import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';

class LoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.login);
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'].toString().trim();
        final role = responseData['role'].toString().trim();

          AuthenticationService().setToken(token);
          AuthenticationService().setRole(role);

        return {
          'success': true,
          'role': role,
          'token': token,
        };
      }
      
      return {
        'success': false,
        'error': 'Login failed: Password or email is incorrect',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}