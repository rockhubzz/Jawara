import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart'; // your existing AuthService that exposes baseUrl

class KategoriIuranService {
  static String? get baseUrl => AuthService.baseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? prefs.getString('api_token');
  }

  static Map<String, String> _headers(String? token, {bool jsonBody = true}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (jsonBody) headers['Content-Type'] = 'application/json';
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // GET all
  static Future<List<Map<String, dynamic>>> getAll() async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("$baseUrl/kategori-iuran"),
      headers: _headers(token, jsonBody: false),
    );
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to load kategori iuran (${resp.statusCode})');
    }
  }

  // CREATE
  static Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.post(
      Uri.parse("$baseUrl/kategori-iuran"),
      headers: _headers(token),
      body: json.encode(body),
    );

    final data = json.decode(resp.body);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return {"success": true, "data": data};
    } else {
      return {"success": false, "errors": data};
    }
  }

  // UPDATE
  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, dynamic> body,
  ) async {
    final token = await _getToken();
    final resp = await http.put(
      Uri.parse("$baseUrl/kategori-iuran/$id"),
      headers: _headers(token),
      body: json.encode(body),
    );

    final data = json.decode(resp.body);
    if (resp.statusCode == 200) return {"success": true, "data": data};
    return {"success": false, "errors": data};
  }

  // DELETE
  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse("$baseUrl/kategori-iuran/$id"),
      headers: _headers(token, jsonBody: false),
    );
    return resp.statusCode == 200;
  }
}
