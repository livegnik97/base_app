class LoginDto {
  final String emailOrPhone;
  final String password;
  final String? firebaseToken;
  final String? platform;

  LoginDto({
    required this.emailOrPhone,
    required this.password,
    this.firebaseToken,
    this.platform,
  });

  Map<String, dynamic> toMap() => {
    'emailOrPhone': emailOrPhone,
    'password': password,
    if (firebaseToken != null && firebaseToken!.isNotEmpty)
      'firebaseToken': firebaseToken,
    if (platform != null) 'platform': platform,
  };
}
