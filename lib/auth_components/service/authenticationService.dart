class AuthenticationService {
  static final AuthenticationService _instance = AuthenticationService._internal();
  String? _token;

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
}
