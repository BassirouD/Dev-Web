class AuthenticationRequest {
  final String email;
  final String password;

  AuthenticationRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
