 
class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';
  static const String login = '$baseUrl/auth/authenticate';
  static const String signup = '$baseUrl/auth/register/user';
  static const String verifyEmail = '$baseUrl/auth/activate-account?token=';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String fetchmovies = '$baseUrl/homepage/movies';
  static const String metadata = '$baseUrl/homepage/metadata';
  static const String fetchvideoURL= '$baseUrl/video/getVideos?id=';
  static  String fetchThumbnail(int id) =>  '$baseUrl/videos/$id/thumbnail';
  static const String submitComments = '$baseUrl/video/comment';
  static const String adminPendingMovies = '$baseUrl/reviewing-content';
  static const String approveMovie = '$adminPendingMovies/approve';
  static const String rejectMovie = '$adminPendingMovies/reject';
  static String signupFilmmaker = '$baseUrl/auth/register/filmmaker';
  static String viewPorfile = '$baseUrl/user/profile';
  static String userRating = '$baseUrl/video/Rating';
  static String adminSignup = '$baseUrl/signup/admin';
  static String rejectedMovieList = '$baseUrl/reviewing/rejected/content';
}
