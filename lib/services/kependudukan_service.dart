import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KependudukanService {
  static String? get baseUrl => AuthService.baseUrl;

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> getGlance() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/rekap-penduduk'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return data; // return seluruh map
    } else {
      throw Exception('Gagal mengambil data: ${resp.statusCode}');
    }
  }
}
