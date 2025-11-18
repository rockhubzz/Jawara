import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use emulator host for Android emulator: 10.0.2.2
  // For iOS simulator use 127.0.0.1
  // For physical device use your computer LAN IP: e.g. 192.168.1.10
  static const String baseUrl = 'http://192.168.66.189:8000/api';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_token', token);
      // Optionally store user
      await prefs.setString('user', jsonEncode(data['user']));
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    if (token == null) return;
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
    await prefs.remove('user');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  static Future<Map<String, dynamic>?> me() async {
    final token = await getToken();
    if (token == null) return null;
    final resp = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    }
    return null;
  }
}
