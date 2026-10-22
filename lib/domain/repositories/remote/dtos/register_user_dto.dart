class RegisterUserDto {
  final String password;
  final String name;
  final String? lastName;
  final String email;
  final String phone;
  final String? phoneAlt;
  final bool? subscribedNewsletter;

  RegisterUserDto({
    required this.password,
    required this.name,
    this.lastName,
    required this.email,
    required this.phone,
    this.phoneAlt,
    this.subscribedNewsletter,
  });

  Map<String, dynamic> toMap() => {
    'password': password,
    'name': name,
    if (lastName != null) 'lastName': lastName,
    'email': email,
    'phone': phone,
    if (phoneAlt != null) 'phoneAlt': phoneAlt,
    if (subscribedNewsletter != null)
      'subscribedNewsletter': subscribedNewsletter,
  };
}
