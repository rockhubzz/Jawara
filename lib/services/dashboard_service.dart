import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static String? get baseUrl => AuthService.baseUrl;

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // GET SALDO
  static Future<int> getSaldo() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/saldo'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      // Backend format asumsi: { "saldo": 123456 }
      return (data['saldo'] as num).toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }

  static Future<int> getKeluarga() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/keluarga'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      return (data['total_keluarga'] as num).toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }

  static Future<int> getKegiatan() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/kegiatan'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);

      return (data['total_kegiatan'] as num).toInt();
    } else {
      throw Exception('Gagal mengambil saldo: ${resp.statusCode}');
    }
  }
}
