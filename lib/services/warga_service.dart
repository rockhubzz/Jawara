import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class WargaService {
  static String? get baseUrl => AuthService.baseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/warga"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    throw Exception("Failed to load warga");
  }

  static Future<Map<String, dynamic>> getById(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/warga/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception("Failed to load detail");
  }

  static Future<bool> create(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/warga"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: data,
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> update(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/warga/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: data,
    );

    return response.statusCode == 200;
  }

  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/warga/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }
}
