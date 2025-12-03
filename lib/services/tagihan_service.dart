import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagihanService {
  static String? get baseUrl => AuthService.baseUrl;

  // =========================================================
  // GET TOKEN (same style as RumahService)
  // =========================================================
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? prefs.getString('api_token');
  }

  // =========================================================
  // GET ALL TAGIHAN
  // Backend should return: [ { ..tagihan.. }, ... ]
  // =========================================================
  static Future<List<Map<String, dynamic>>> getAll() async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("$baseUrl/tagihan"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Failed to load tagihan: ${resp.statusCode}");
    }
  }

  // =========================================================
  // GET BY ID
  // =========================================================
  static Future<Map<String, dynamic>> getById(int id) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("$baseUrl/tagihan/$id"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(resp.body));
    } else {
      throw Exception("Failed to load tagihan detail");
    }
  }

  // =========================================================
  // CREATE TAGIHAN
  // Returns TRUE on success (same as RumahService)
  // =========================================================
  static Future<bool> createAll(Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.post(
      Uri.parse("$baseUrl/tagihan/semua"),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  static Future<bool> createByKeluarga(Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.post(
      Uri.parse("$baseUrl/tagihan"),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  // =========================================================
  // UPDATE
  // =========================================================
  static Future<bool> update(int id, Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.put(
      Uri.parse("$baseUrl/tagihan/$id"),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    return resp.statusCode == 200;
  }

  // =========================================================
  // DELETE
  // =========================================================
  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse("$baseUrl/tagihan/$id"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return resp.statusCode == 200;
  }
}
