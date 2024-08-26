import 'package:book_social_network/models/registration_request.dart';
import 'package:book_social_network/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authentication_request.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final HttpService _httpService;
  String? _token;
  String? _username;
  bool? _isNotValidToken;
  String? get token => _token;
  String? get username => _username;

  AuthProvider(this._httpService);

  Future<void> login(String email, String password) async {
    try {
      final request = AuthenticationRequest(email: email, password: password);
      final response = await AuthService().authenticate(request);
      _token = response?.token;
      parseJWT(_token!);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('token', _token!);
      _httpService.updateToken(_token);
      isTokenNotValid();
      _httpService.updateIsTokenNotValid(_isNotValidToken!);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(RegistrationRequest request) async {
    try {
      await AuthService().registration(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> activate(String token) async {
    try {
      await AuthService().activateAccount(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      _httpService.updateToken(token);
      notifyListeners();
    }
  }

  void logout() async {
    _token = null;
    _httpService.updateToken(_token);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    notifyListeners();
  }

  void parseJWT(String jwt) async {
    // Decode the JWT
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);

    // Extract fields from the decoded token
    _username = decodedToken['fullName']; // or any key your JWT contains
    List<dynamic>? roles = decodedToken[
        'authorities']; // Assuming roles are stored in 'authorities'
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', username!);
    // Do something with the extracted values
    // print('Username: $username');
    // print('Roles: $roles');
    //
    // // Check if the user has a specific role
    // bool isAdmin = roles != null && roles.contains('ROLE_ADMIN');
    // print('Is Admin: $isAdmin');
  }

  bool isTokenValid() {
    final token = _token;

    if (token == null || token.isEmpty) {
      return false; // No token found
    }

    // Decode the token and check if it's expired
    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (isTokenExpired) {
      // If token is expired, clear the local storage
      _clearToken();
      return false;
    }

    return true;
  }

  // Method to check if the token is NOT valid
  bool isTokenNotValid() {
    _isNotValidToken = !isTokenValid();
    return !isTokenValid();
  }

  // Clear token from SharedPreferences
  Future<void> _clearToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    _token = null;
    _httpService.updateToken(_token);
    notifyListeners();
  }
}
