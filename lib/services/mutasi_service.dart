import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class MutasiService {
  static String get baseUrl => "${AuthService.baseUrl}/mutasi-keluarga";

  static Future<String?> _getToken() async {
    return await AuthService.getToken();
  }

  static Map<String, String> _jsonHeaders(String? token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET paginated list
  static Future<Map<String, dynamic>> getAll({int page = 1}) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("$baseUrl?page=$page"),
      headers: _jsonHeaders(token),
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load mutasi (${resp.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> getById(int id) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: _jsonHeaders(token),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load mutasi detail');
    }
  }

  static Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.post(
      Uri.parse(baseUrl),
      headers: _jsonHeaders(token),
      body: json.encode(body),
    );
    return json.decode(resp.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, dynamic> body,
  ) async {
    final token = await _getToken();
    final resp = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: _jsonHeaders(token),
      body: json.encode(body),
    );
    return json.decode(resp.body) as Map<String, dynamic>;
  }

  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: _jsonHeaders(token),
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> jsonResp = json.decode(resp.body);
      return jsonResp['success'] == true;
    }
    return false;
  }
}
