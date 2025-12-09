import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SemuaPemasukanService {
  static String? get baseUrl => AuthService.baseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? prefs.getString('api_token');
  }

  static Future<Map<String, dynamic>> getPemasukan() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse("${baseUrl}/smPemasukan"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return json.decode(resp.body);
  }
}
