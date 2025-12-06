import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeluargaService {
  static String? get baseUrl => AuthService.baseUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // =============================
  // GET ALL DATA
  // =============================
  // static Future<List<Map<String, dynamic>>> getKeluarga() async {
  //   try {
  //     final token = await _getToken();

  //     final response = await http.get(
  //       Uri.parse("$baseUrl/keluarga"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final List data = json.decode(response.body);
  //       return data.map((e) => Map<String, dynamic>.from(e)).toList();
  //     } else {
  //       throw Exception("Failed to load data: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     throw Exception("Error fetching data: $e");
  //   }
  // }

  static Future<List<Map<String, dynamic>>> getKeluarga() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/keluarga"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    throw Exception("Failed to load keluarga");
  }

  // =============================
  // GET DETAIL (BY ID)
  // =============================
  static Future<Map<String, dynamic>?> getKeluargaById(int id) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/keluarga/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // =============================
  // CREATE
  // =============================
  static Future<bool> createKeluarga(Map<String, dynamic> body) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/keluarga"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      return response.statusCode == 201; // Laravel "created"
    } catch (e) {
      return false;
    }
  }

  // =============================
  // UPDATE
  // =============================
  static Future<bool> updateKeluarga(int id, Map<String, dynamic> body) async {
    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse("$baseUrl/keluarga/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // =============================
  // DELETE
  // =============================
  static Future<bool> deleteKeluarga(int id) async {
    try {
      final token = await _getToken();

      final response = await http.delete(
        Uri.parse("$baseUrl/keluarga/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
