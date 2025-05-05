import 'package:tevly_client/auth_components/service/environmentAuthService.dart';

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
  static String get adminPendingMovies => '$baseUrl/admin/pending-movies';
  static String approveMovie(int id) => '$baseUrl/admin/approve-movie/$id';
  static String rejectMovie(int id) => '$baseUrl/admin/reject-movie/$id';
}
