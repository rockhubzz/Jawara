import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'network_discovery.dart';

class AuthService {
  static String? ip;

  static String? get baseUrl {
    if (ip == null) return "http://192.168.75.96:8000/api"; // ip address api
    return "http://$ip:8000/api";
  }

  static Future<bool> init() async {
    final discoveredIp = await NetworkDiscovery.discoverServer();

    if (discoveredIp != null) {
      ip = discoveredIp;
      print("✅ Laravel server found at: $ip");
      return true;
    }

    print("⚠ Could not find Laravel server on LAN");
    ip = null;
    return false;
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    if (baseUrl == null) {
      return {'success': false, 'message': 'Server not found on LAN'};
    }

    final response = await http.post(
      Uri.parse("${baseUrl!}/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final token = await getToken();
    if (token == null) return;

    if (baseUrl == null) return;

    await http.post(
      Uri.parse("${baseUrl!}/logout"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('api_token');
    prefs.remove('user');
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  // GET CURRENT USER
  static Future<Map<String, dynamic>?> me() async {
    final token = await getToken();
    if (token == null) return null;
    if (baseUrl == null) return null;

    final resp = await http.get(
      Uri.parse("${baseUrl!}/me"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    }
    return null;
  }
}
