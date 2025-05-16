class UserInfo {
  final String fullName;
  final String email;
   final String birthDate;

  UserInfo({
    required this.fullName,
    required this.email,
     required this.birthDate,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
       birthDate: json['birthDate'] ?? '',
    );
  }
}