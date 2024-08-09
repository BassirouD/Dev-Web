import 'package:flutter/material.dart';
import '../models/authentication_request.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final request = AuthenticationRequest(email: email, password: password);
      final response = await AuthService().authenticate(request);
      _token = response?.token;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
