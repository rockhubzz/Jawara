import 'dart:convert';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class PemasukanService {
  static String? get baseUrl => AuthService.baseUrl;

  static Future<Map<String, dynamic>> getAll(int page) async {
    final uri = Uri.parse(
      "$baseUrl/pemasukan",
    ).replace(queryParameters: {'page': page.toString()});

    final res = await http.get(uri);

    return jsonDecode(res.body);
  }

  static Future<bool> create(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/pemasukan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 200;
  }

  static Future<bool> update(int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/pemasukan/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 200;
  }

  static Future<bool> delete(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/pemasukan/$id"));
    return res.statusCode == 200;
  }
}
