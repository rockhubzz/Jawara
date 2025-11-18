import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "http://192.168.66.189:8000/api";

  // ===== Token Getter =====
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ===== GET All Users =====
  static Future<List<dynamic>> getUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/users"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch users");
  }

  // ============================================================
  //                      CREATE USER
  // ============================================================
  static Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String hp,
    required String password,
    required String role,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "hp": hp,
        "password": password,
        "password_confirmation": password,
        "role": role,
      },
    );

    if (response.statusCode == 201) {
      return {"success": true};
    }

    return {
      "success": false,
      "message":
          jsonDecode(response.body)["message"] ?? "Gagal menambahkan user",
      "errors": jsonDecode(response.body)["errors"] ?? {},
    };
  }

  // ============================================================
  //                      UPDATE USER
  // ============================================================
  static Future<Map<String, dynamic>> updateUser({
    required int id,
    required String name,
    required String email,
    required String hp,
    required String role,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final response = await http.put(
        Uri.parse("$baseUrl/users/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"name": name, "email": email, "hp": hp, "role": role},
      );

      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // ============================================================
  //                      DELETE USER
  // ============================================================
  static Future<bool> deleteUser(int id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/users/$id"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return response.statusCode == 200;
  }

  // ============================================================
  //            GET USERNAME untuk AppDrawer ( /api/me )
  // ============================================================
  static Future<String?> getUsername() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["name"];
    }

    return null;
  }

  static Future<String?> getEmail() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["email"];
    }

    return null;
  }
}
