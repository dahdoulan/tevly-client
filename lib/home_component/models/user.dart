class UserInfo {
  final String username;
  final String email;
  final String phone;
  final String birthdate;

  UserInfo({
    required this.username,
    required this.email,
    required this.phone,
    required this.birthdate,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthdate: json['birthdate'] ?? '',
    );
  }
}