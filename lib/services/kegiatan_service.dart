import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KegiatanService {
  static String? get baseUrl => AuthService.baseUrl;

  // token getter
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? prefs.getString('api_token');
  }

  // GET all kegiatan
  static Future<List<Map<String, dynamic>>> getAll() async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("${baseUrl}/kegiatan"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Failed to load kegiatan: ${resp.statusCode}");
    }
  }

  // GET by id
  static Future<Map<String, dynamic>> getById(int id) async {
    final token = await _getToken();
    final resp = await http.get(
      Uri.parse("${baseUrl}/kegiatan/$id"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(resp.body));
    } else {
      throw Exception("Failed to load kegiatan detail");
    }
  }

  // CREATE
  static Future<Map<String, dynamic>> tambahKegiatan(
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/kegiatan");

      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: data, // langsung kirim form-data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Gagal menambahkan kegiatan",
          "status": response.statusCode,
          "response": response.body,
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // UPDATE
  static Future<Map<String, dynamic>> update(
    int id,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _getToken();
      final resp = await http.put(
        Uri.parse("${baseUrl}/kegiatan/$id"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return {
          "success": true,
          "data": jsonDecode(resp.body),
        };
      } else {
        return {
          "success": false,
          "message": "Gagal memperbarui kegiatan",
          "status": resp.statusCode,
          "response": resp.body,
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }


  // DELETE
  static Future<bool> delete(int id) async {
    final token = await _getToken();
    final resp = await http.delete(
      Uri.parse("${baseUrl}/kegiatan/$id"),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return true;
  }

  static Future<Map<String, dynamic>> getGlance() async {
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
      return data; // return seluruh map
    } else {
      throw Exception('Gagal mengambil data: ${resp.statusCode}');
    }
  }

  static Future<List<dynamic>> countByKategori() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/kegiatan/countByKategori'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data kategori');
    }
  }

  static Future<List<dynamic>> countKegiatanPerBulan() async {
    final token = await _getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/glance/kegiatan/countKegiatanPerBulan'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data kategori');
    }
  }
}
