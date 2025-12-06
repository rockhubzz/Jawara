import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // adjust import path

class BroadcastService {
  static String get baseUrl => "${AuthService.baseUrl}";

  // helper token getter (matches your app style)
  static Future<String?> _getToken() async {
    return await AuthService.getToken();
  }

  static Map<String, String> _jsonHeaders([String? token]) {
    final h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) h['Authorization'] = 'Bearer $token';
    return h;
  }

  static Future<Map<String, dynamic>> getById(int id) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("${baseUrl}/broadcasts/$id"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(resp.body));
    } else {
      throw Exception("Failed to load kegiatan detail");
    }
  }

  // GET all
  static Future<Map<String, dynamic>> getAll() async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("${baseUrl}/broadcasts"),
      headers: _jsonHeaders(token),
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load broadcasts (${resp.statusCode})');
    }
  }

  // CREATE
  static Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final token = await _getToken();
    final resp = await http.post(
      Uri.parse("$baseUrl/broadcasts"),
      headers: _jsonHeaders(token),
      body: jsonEncode(body),
    );
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  // UPDATE
  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, dynamic> body,
  ) async {
    final token = await _getToken();
    final resp = await http.put(
      Uri.parse("$baseUrl/broadcasts/$id"),
      headers: _jsonHeaders(token),
      body: jsonEncode(body),
    );
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  // DELETE
  // returns true if deleted
  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse("$baseUrl/broadcasts/$id"),
      headers: _jsonHeaders(token),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is Map && body['success'] == true) return true;
      return resp.statusCode == 200;
    }
    return false;
  }
}
