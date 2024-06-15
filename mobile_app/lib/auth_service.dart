import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, String>?> authenticate(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.8.171:3001/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['role'] != null) {
        return {
          'username': username,
          'email': data['email'] ?? '',
          'status': data['status'] ?? '',
          'name': data['name'] ?? '',
        };
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, String>> getUserDetails(String username) async {
    final response =
        await http.get(Uri.parse('http://192.168.8.171:3001/user/$username'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'status': data['status'] ?? '',
      };
    } else {
      throw Exception('Failed to load user details');
    }
  }
}
