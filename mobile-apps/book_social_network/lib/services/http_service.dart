import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart'; // Utilisé pour obtenir le nom de fichier

class HttpService {
  final String _baseUrl = 'http://10.245.172.239:8088/api/v1';
  bool _isTokenNotValid = false;
  String? _token;

  HttpService(this._token);

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = _createHeaders();

    return await http.get(url, headers: headers);
  }

  Future<http.Response> patch(String endpoint, dynamic body) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = _createHeaders();

    return await http.patch(url, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = _createHeaders();

    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  // Méthode pour uploader des fichiers
  Future<http.StreamedResponse> postFile(String endpoint, File file) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(_createHeadersFile())
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: basename(file.path), // Utilise le nom du fichier
        ),
      );

    return await request.send();
  }

  Map<String, String> _createHeadersFile() {
    return {
      if (!_isTokenNotValid) 'Authorization': 'Bearer $_token',
    };
  }

  Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
      if (!_isTokenNotValid) 'Authorization': 'Bearer $_token',
    };
  }

  void updateToken(String? token) {
    _token = token;
  }

  void updateIsTokenNotValid(bool isValid) {
    _isTokenNotValid = isValid;
  }
}
