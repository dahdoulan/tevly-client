class ApiConstants {
  static const String baseUrl = 'https://4a74-37-202-98-21.ngrok-free.app/api';
  static const String login = '$baseUrl/auth/authenticate';
  static const String signup = '$baseUrl/auth/register/user';
  static const String verifyEmail = '$baseUrl/auth/activate-account?token=';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String fetchmovies = '$baseUrl/homepage/movies';
  static const String metadata = '$baseUrl/homepage/metadata';
  static const String fetchThumbnail = '$baseUrl/videos';
  static const String submitComments = '$baseUrl/video/comment'; // Updated to match backend endpoint
}
