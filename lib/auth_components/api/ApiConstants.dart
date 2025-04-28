class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';
  static const String login = '$baseUrl/auth/authenticate';
  static const String signup = '$baseUrl/auth/register/user';
  static const String signupFilmmaker = '$baseUrl/auth/register/filmmaker';
  static const String verifyEmail = '$baseUrl/auth/activate-account?token=';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String fetchmovies = '$baseUrl/homepage/movies';
  static const String metadata = '$baseUrl/homepage/metadata';
  static const String fetchThumbnail = '$baseUrl/videos';  
}
