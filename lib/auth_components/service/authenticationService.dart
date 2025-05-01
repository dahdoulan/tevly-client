class AuthenticationService {
  static final AuthenticationService _instance = AuthenticationService._internal();
  String? _token;
   String? _role;

  AuthenticationService._internal();

  factory AuthenticationService() {
    return _instance;
  }

  void setToken(String token) {
    _token = token;
  }

  String? getToken() {
    return _token;
  }

  void setRole(String role) {
    _role = role;
  }
  String? getRole() {
    return _role;
  }
  void clearToken() {
    _token =' ';
    _role = '';
  }



}
