import 'dart:convert';
import 'package:book_social_network/models/registration_request.dart';
import 'package:http/http.dart' as http;
import '../models/authentication_request.dart';
import '../models/authentication_response.dart';

class AuthService {
  final String _baseUrl = 'http://10.245.172.239:8088/api/v1';

  Future<AuthenticationResponse?> authenticate(
      AuthenticationRequest request) async {
    final url = Uri.parse('$_baseUrl/auth/authenticate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthenticationResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to authenticate');
    }
  }

  Future<void> registration(RegistrationRequest request) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()));
    if (response.statusCode == 202) {
      print(
          "********************************************************************");
      print("registration");
      print(
          "********************************************************************");
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to register');
    }
  }

  Future<void> activateAccount(String token) async {
    final url = Uri.parse('$_baseUrl/auth/activate-account?token=$token');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print(
          "********************************************************************");
      print("activated");
      print(
          "********************************************************************");
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to register');
    }
  }
}
