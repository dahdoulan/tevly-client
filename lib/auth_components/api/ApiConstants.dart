import 'package:tevly_client/auth_components/service/environmentAuth.dart';

class ApiConstants {
  static String get baseUrl => Environment.baseUrl;
  static String login = '$baseUrl/auth/authenticate';
  static String signup = '$baseUrl/auth/register/user';
  static String signupFilmmaker = '$baseUrl/auth/register/filmmaker';
  static String verifyEmail = '$baseUrl/auth/activate-account?token=';
  static String forgotPassword = '$baseUrl/auth/forgot-password';
  static String fetchmovies = '$baseUrl/homepage/movies';
  static String metadata = '$baseUrl/homepage/metadata';
  static String fetchThumbnail = '$baseUrl/videos';  
}
